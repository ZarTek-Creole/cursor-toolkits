"""
Prompts generator for Cursor IDE
Generates .cursor/prompts.json and .cursor/commands.json for templates
"""
import json
import sys
import os
from pathlib import Path
from typing import Dict, List, Optional


def load_prompts() -> Dict:
    """Load prompts from prompts.json"""
    prompts_file = Path(__file__).parent.parent / "prompts" / "prompts.json"
    if not prompts_file.exists():
        return {}
    with open(prompts_file, 'r', encoding='utf-8') as f:
        return json.load(f)


def load_commands() -> Dict:
    """Load commands from commands.json"""
    commands_file = Path(__file__).parent.parent / "commands" / "commands.json"
    if not commands_file.exists():
        return {}
    with open(commands_file, 'r', encoding='utf-8') as f:
        return json.load(f)


def generate_prompts_file(template_name: str, output_dir: Path):
    """Generate .cursor/prompts.json for a template"""
    prompts_data = load_prompts()
    template_prompts = prompts_data.get(template_name, {})
    
    if not template_prompts:
        return False
    
    prompts_file = output_dir / ".cursor" / "prompts.json"
    prompts_file.parent.mkdir(parents=True, exist_ok=True)
    
    # Format for Cursor prompts.json
    cursor_prompts = {
        "prompts": []
    }
    
    for name, prompt in template_prompts.items():
        cursor_prompts["prompts"].append({
            "name": name,
            "prompt": prompt,
            "category": "development"
        })
    
    with open(prompts_file, 'w', encoding='utf-8') as f:
        json.dump(cursor_prompts, f, indent=2, ensure_ascii=False)
    
    return True


def generate_commands_file(template_name: str, output_dir: Path):
    """Generate .cursor/commands.json for a template"""
    commands_data = load_commands()
    template_commands = commands_data.get(template_name, {})
    
    if not template_commands:
        return False
    
    commands_file = output_dir / ".cursor" / "commands.json"
    commands_file.parent.mkdir(parents=True, exist_ok=True)
    
    cursor_commands = {
        "commands": template_commands.get("commands", [])
    }
    
    with open(commands_file, 'w', encoding='utf-8') as f:
        json.dump(cursor_commands, f, indent=2, ensure_ascii=False)
    
    return True


def generate_for_template(template_name: str, output_dir: str):
    """Generate prompts and commands for a template"""
    output_path = Path(output_dir)
    
    prompts_ok = generate_prompts_file(template_name, output_path)
    commands_ok = generate_commands_file(template_name, output_path)
    
    return prompts_ok or commands_ok


def main():
    """Main function - can be called from CLI"""
    if len(sys.argv) >= 3:
        template_name = sys.argv[1]
        output_dir = sys.argv[2]
        generate_for_template(template_name, output_dir)
    else:
        # Generate for all templates
        toolkits_dir = Path(__file__).parent.parent.parent
        templates_dir = toolkits_dir / "templates"
        
        if templates_dir.exists():
            for template_dir in templates_dir.iterdir():
                if template_dir.is_dir() and not template_dir.name.startswith('.'):
                    template_name = template_dir.name
                    if (template_dir / "template.json").exists():
                        generate_for_template(template_name, str(template_dir))


if __name__ == '__main__':
    main()
