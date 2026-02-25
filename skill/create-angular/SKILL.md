name: create_angular_workspace
description: Creates a new Angular workspace with optional SSR and installs custom AI rules.
inputs:
  - id: workspace_name
    name: Workspace Name
    type: string
    description: The name of the folder for the new workspace
  - id: ssr
    name: Server-Side Rendering
    type: boolean
    default: false
---

## When to Use This Skill

Use this skill when the user wants to create a new Angular workspace using the Angular CLI (`ng new`), and wants the workspace configured with custom AI rules.

## Instructions

1. **Read Setup Instructions**
   Review the [setup instructions](agent/rules/setupInstruction.md) to understand how to initialize the project and install dependencies.

   *Action:* Read `agent/rules/setupInstruction.md`.
