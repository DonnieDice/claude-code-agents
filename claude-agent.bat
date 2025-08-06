@echo off
:: Claude Agent Manager - Windows Batch Wrapper
:: Makes it easy to use agents from anywhere

powershell -ExecutionPolicy Bypass -File "%~dp0sync-agents.ps1" %*