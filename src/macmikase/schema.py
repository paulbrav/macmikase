"""Pydantic models for macmikase configuration validation.

This module defines the schema for macmikase.yaml configuration files,
enabling validation and providing better error messages.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any

import yaml
from pydantic import BaseModel, Field, field_validator


class PackageItem(BaseModel):
    """Brew or Cask package configuration."""

    name: str
    desc: str | None = None
    install: bool = True
    note: str | None = None


class GoToolItem(BaseModel):
    """Go tool configuration."""

    name: str
    package: str
    desc: str | None = None
    install: bool = True


class NpmItem(BaseModel):
    """NPM package configuration."""

    name: str
    desc: str | None = None
    version: str = "latest"
    install: bool = True


class UvToolItem(BaseModel):
    """UV tool configuration."""

    name: str
    desc: str | None = None
    install: bool = True


class DefaultsConfig(BaseModel):
    """Default settings."""

    install: bool = True
    theme: str = "nord"


class WebItem(BaseModel):
    """Web application configuration."""

    name: str
    desc: str | None = None
    url: str
    icon_url: str | None = None
    install: bool = True


class WebConfig(BaseModel):
    """Web applications configuration."""

    apps: list[WebItem] = Field(default_factory=list)


class ThemesConfig(BaseModel):
    """Themes configuration."""

    default: str = "nord"
    available: list[str] = Field(default_factory=list)
    paths: dict[str, str] = Field(default_factory=dict)


class MacmikaseConfig(BaseModel):
    """Root configuration model for macmikase.yaml."""

    defaults: DefaultsConfig = Field(default_factory=DefaultsConfig)
    brew: dict[str, list[PackageItem]] = Field(default_factory=dict)
    cask: dict[str, list[PackageItem]] = Field(default_factory=dict)
    web: WebConfig = Field(default_factory=WebConfig)
    npm: list[NpmItem | str] = Field(default_factory=list)
    uv_tools: list[UvToolItem | str] = Field(default_factory=list)
    cargo_tools: list[PackageItem] = Field(default_factory=list)
    go_tools: list[GoToolItem] = Field(default_factory=list)
    themes: ThemesConfig = Field(default_factory=ThemesConfig)
    scripts: list[Any] = Field(default_factory=list)

    @field_validator("npm", "uv_tools", mode="before")
    @classmethod
    def normalize_string_items(cls, v: list) -> list:
        """Convert string items to dict format."""
        if not isinstance(v, list):
            return v
        result = []
        for item in v:
            if isinstance(item, str):
                result.append({"name": item})
            else:
                result.append(item)
        return result


def load_and_validate(path: Path | str) -> MacmikaseConfig:
    """Load and validate a macmikase.yaml configuration file.

    Args:
        path: Path to the configuration file.

    Returns:
        Validated MacmikaseConfig object.

    Raises:
        pydantic.ValidationError: If the configuration is invalid.
        FileNotFoundError: If the file doesn't exist.
    """
    path = Path(path)
    with open(path) as f:
        data = yaml.safe_load(f)
    return MacmikaseConfig.model_validate(data)


def validate_config(path: Path | str) -> tuple[bool, list[str]]:
    """Validate a configuration file and return errors if any.

    Args:
        path: Path to the configuration file.

    Returns:
        Tuple of (is_valid, list_of_error_messages)
    """
    try:
        load_and_validate(path)
        return True, []
    except Exception as e:
        return False, [str(e)]


def _main() -> None:
    """CLI entry point for configuration validation."""
    import argparse
    import sys

    parser = argparse.ArgumentParser(description="Validate macmikase configuration")
    default_config = os.environ.get("MACMIKASE_CONFIG", "macmikase.yaml")
    parser.add_argument(
        "config",
        nargs="?",
        default=default_config,
        help="Path to config file (default: macmikase.yaml or $MACMIKASE_CONFIG)",
    )
    parser.add_argument(
        "--quiet",
        "-q",
        action="store_true",
        help="Only print errors",
    )

    args = parser.parse_args()

    is_valid, errors = validate_config(args.config)

    if is_valid:
        if not args.quiet:
            print(f"✓ Configuration is valid: {args.config}")
        sys.exit(0)
    else:
        print(f"✗ Configuration errors in {args.config}:", file=sys.stderr)
        for error in errors:
            print(f"  {error}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    _main()
