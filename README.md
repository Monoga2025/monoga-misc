# Misc: SolidWorks Parts and Windows Utility Scripts

Small, unrelated artifacts from coursework and daily tooling.

## `solidworks-parts/`

Four SolidWorks part files from a mechanisms course (activity, exercise, partial exam, and one more part). Open with SolidWorks.

## `scripts/`

| File | What it does |
|---|---|
| `Control-Scroll-y-Touchpad.bat` | Console menu to toggle a mouse scroll filter and enable/disable one specific ELAN touchpad (elevates via UAC, targets a single hardware instance ID). Machine-specific: the ID and the referenced `Filtro-Scroll-Windows.ps1` are not portable or included. |
| `CRM.bat` | Start/stop menu for a local dev stack: starts a portable Postgres, the API (turbo), the Next.js app and an optional AI agent, waits for the ports, and opens the app. Set `CRM_ROOT` and `CRM_PG` first. The project it launches is not included. |

## Status

Utilities for personal use, shown as-is. Not packaged or tested elsewhere.
