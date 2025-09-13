# TODO:
# 1. Fix white screen after uploading document
# 2. After running git commands and things like that, takes to /git page,
# refreshing which we get Method not allowed error.

import os
import shutil
import subprocess
from datetime import datetime

from beancount.core.data import Open
from beancount.loader import load_file
from fastapi import FastAPI, Form, Request, UploadFile
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

MAX_FILE_SIZE = 2 * 1024 * 1024  # 5 MB


# --- Config ---
# TODO: use env for DATA_DIR
DATA_DIR = os.getenv("DATA_DIR")
if not DATA_DIR:
    raise Exception("data dir not defined")
DOCS_DIR = os.path.join(DATA_DIR, "documents")
BEAN_FILE = os.path.join(DATA_DIR, "main.beancount")
os.makedirs(DOCS_DIR, exist_ok=True)


def get_accounts():
    try:
        entries, _, _ = load_file(BEAN_FILE)
        return sorted([entry.account for entry in entries if isinstance(entry, Open)])
    except Exception:
        return []


# --- App setup ---
app = FastAPI()
app.mount("/docs", StaticFiles(directory=DOCS_DIR), name="docs")
templates = Jinja2Templates(directory="templates")


def run_git_command(args, cwd=DATA_DIR):
    """Run a git command and return its output (or error)."""
    try:
        result = subprocess.run(
            ["git"] + args, cwd=DATA_DIR, text=True, capture_output=True, check=False
        )
        return result.stdout + result.stderr
    except Exception as e:
        return str(e)


@app.get("/", response_class=HTMLResponse)
async def index(
    request: Request, message: str = None, result: str = None, diff: str = None
):
    if diff is None:
        diff = run_git_command(["diff"])
    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "accounts": get_accounts(),
            "message": message,
            "result": result,
            "diff": diff,
        },
    )


@app.post("/", response_class=HTMLResponse)
async def upload_file(
    request: Request,
    account: str = Form(...),
    file: UploadFile = Form(...),
    date: str = Form(None),
):
    # Check file size
    file.file.seek(0, os.SEEK_END)  # move to end of file
    size = file.file.tell()  # current position = size
    file.file.seek(0)  # reset back to start

    if size > MAX_FILE_SIZE:
        return templates.TemplateResponse(
            "index.html",
            {
                "request": request,
                "accounts": get_accounts(),
                "message": f"❌ Upload failed: {file.filename} is larger than 5MB",
                "result": None,
                "diff": None,
            },
        )

    date_str = date or datetime.today().strftime("%Y-%m-%d")
    dest_dir = os.path.join(DOCS_DIR, *account.split(":"))
    os.makedirs(dest_dir, exist_ok=True)
    filename = f"{date_str}.{file.filename}"
    file_path = os.path.join(dest_dir, filename)

    with open(file_path, "wb") as f:
        shutil.copyfileobj(file.file, f)


@app.post("/git", response_class=HTMLResponse)
async def git_command(request: Request, command: str = Form(...)):
    parts = command.split()
    output = run_git_command(parts)
    diff = run_git_command(["diff"])
    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "accounts": get_accounts(),
            "message": None,
            "result": output,
            "diff": diff,
        },
    )


@app.post("/commit", response_class=HTMLResponse)
async def git_commit(
    request: Request, message: str = Form(...), description: str = Form("")
):
    run_git_command(["add", "."])
    output = run_git_command(["commit", "-m", message + "\n\n" + description])
    diff = run_git_command(["diff"])
    return templates.TemplateResponse(
        "index.html",
        {
            "request": request,
            "accounts": get_accounts(),
            "message": "Committed changes" if "error" not in output.lower() else None,
            "result": output,
            "diff": diff,
        },
    )
