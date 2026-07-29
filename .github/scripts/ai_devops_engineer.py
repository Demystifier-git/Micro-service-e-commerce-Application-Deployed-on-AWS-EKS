import os
import pathlib
import sys

from google import genai
from google.genai import types

###############################################################################
# Configuration
###############################################################################

API_KEY = os.getenv("GEMINI_API_KEY")

if not API_KEY:
    print("ERROR: GEMINI_API_KEY not found.")
    sys.exit(1)

REPORT_FILE = pathlib.Path("ai_report.md")

LOG_FILES = {
    "Terraform Format": pathlib.Path("fmt.log"),
    "Terraform Validate": pathlib.Path("validate.log"),
    "TFLint": pathlib.Path("tflint.log"),
    "tfsec": pathlib.Path("tfsec.log"),
    "Checkov": pathlib.Path("checkov.log"),
    "Trivy": pathlib.Path("trivy.log"),
    "Terraform Plan": pathlib.Path("terraform.log"),
}

###############################################################################
# Read Logs
###############################################################################

logs = []

MAX_CHARS_PER_LOG = 20000

for tool, path in LOG_FILES.items():

    if path.exists():

        content = path.read_text(
            encoding="utf-8",
            errors="ignore"
        )

        if len(content) > MAX_CHARS_PER_LOG:
            content = content[-MAX_CHARS_PER_LOG:]

        logs.append(
            f"""
==============================
{tool}
==============================

{content}
"""
        )

if not logs:
    REPORT_FILE.write_text(
        "# AI DevOps Report\n\n"
        "No log files were found."
    )
    sys.exit(0)

combined_logs = "\n".join(logs)

###############################################################################
# Prompt
###############################################################################

PROMPT = f"""
You are a Principal AWS DevOps Engineer,
Principal Cloud Security Engineer,
and Principal Platform Engineer.

You are reviewing a failed Terraform CI/CD pipeline.

The pipeline contains outputs from:

- terraform fmt
- terraform validate
- TFLint
- tfsec
- Checkov
- Trivy
- Terraform Plan

Your job is NOT merely to summarize.

You must act like a senior engineer reviewing a pull request.

Return Markdown.

# 🤖 AI DevOps Engineer Report

## Executive Summary

Summarize the pipeline health.

---

## Pipeline Status

State which stages passed and which failed.

---

## Findings

Group findings into:

### Critical

### High

### Medium

### Low

For every finding explain:

- Why it happened
- Why it matters
- Which Terraform file is responsible

---

## Root Cause Analysis

Explain the underlying causes.

---

## Exact Terraform Fixes

For every issue provide:

- Terraform file
- Resource
- Exact property to change
- Recommended value

---

## Example Terraform Code

Provide production-ready Terraform snippets.

---

## AWS Best Practices

Explain what AWS recommends.

---

## Safe To Deploy?

Answer:

YES

or

NO

Explain why.

---

## Priority Order

List the fixes in the order they should be completed.

---

## Confidence

Provide a confidence percentage.

Pipeline Logs

{combined_logs}
"""

###############################################################################
# Gemini Client
###############################################################################

client = genai.Client(api_key=API_KEY)

###############################################################################
# Generate Report
###############################################################################

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents=PROMPT,
    config=types.GenerateContentConfig(
        temperature=0.1,
        top_p=0.9,
    ),
)

###############################################################################
# Save Report
###############################################################################

REPORT_FILE.write_text(
    response.text,
    encoding="utf-8",
)

print("AI report generated successfully.")