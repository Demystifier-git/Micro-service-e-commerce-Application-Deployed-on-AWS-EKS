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

LOG_FILE = pathlib.Path("terraform/terraform.log")
REPORT_FILE = pathlib.Path("terraform/ai_report.md")

if not LOG_FILE.exists():
    REPORT_FILE.write_text(
        "# AI Analysis\n\n"
        "Terraform log file was not found.\n"
    )
    sys.exit(0)

###############################################################################
# Read Terraform Log
###############################################################################

terraform_log = LOG_FILE.read_text(encoding="utf-8", errors="ignore")

###############################################################################
# Trim Very Large Logs
###############################################################################

MAX_CHARS = 40000

if len(terraform_log) > MAX_CHARS:
    terraform_log = terraform_log[-MAX_CHARS:]

###############################################################################
# Prompt
###############################################################################

PROMPT = f"""
You are a Principal AWS DevOps Engineer.

Analyze the Terraform deployment log below.

Return your answer in Markdown.

Use this exact format.

# 🤖 AI DevOps Engineer Report

## Executive Summary

One paragraph.

---

## Root Cause

Explain the actual root cause.

---

## AWS Services Involved

List every AWS service involved.

---

## Terraform Files Likely Responsible

List probable files.

Example

modules/eks/main.tf

modules/irsa/alb.tf

terraform/main.tf

---

## Suggested Fix

Explain exactly what should change.

---

## Example Terraform Code

Provide example Terraform code if appropriate.

---

## Safe To Retry?

Yes or No.

Explain why.

---

## Confidence

Provide a confidence percentage.

Terraform Log

{terraform_log}
"""

###############################################################################
# Gemini Client
###############################################################################

client = genai.Client(api_key=API_KEY)

###############################################################################
# Ask Gemini
###############################################################################

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents=PROMPT,
    config=types.GenerateContentConfig(
        temperature=0.2,
    ),
)

###############################################################################
# Save Report
###############################################################################

REPORT_FILE.write_text(response.text, encoding="utf-8")

print("AI report generated successfully.")