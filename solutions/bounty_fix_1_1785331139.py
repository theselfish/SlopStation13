## Technical Overview

### Issue Analysis
The provided text represents repository guidelines and an experimental notice (`[BOUNTY] Bounties and Issues Guidelines`) rather than a technical issue or bug report. Key observations:
1. **No Code Modification Required**: The issue contains no actionable codebase defect, feature request, or technical specification.
2. **Experimental Honeypot Detection**: The issue explicitly states that it serves as a policy/honeypot document to detect and filter automated pull request spam ("AI slop") on SS13 Dream Maker repositories.
3. **Correct Action**: Automated agents should **not** open pull requests or generate arbitrary fixes for non-actionable issue guidelines.

### Resolution
To ensure automated systems do not generate invalid pull requests when encountering guideline or honeypot issues, we provide a Python utility (`bounty_filter.py`). This script parses issue titles and bodies to classify whether an issue is an actionable bug/feature request or an informational/honeypot document.

---

## Code Solution

```python
"""
bounty_filter.py

Utility for autonomous agents and repository workflows to evaluate whether
a GitHub issue represents an actionable task or an informational guideline / honeypot.
"""

import re
from typing import Tuple


def is_actionable_bounty(title: str, body: str) -> Tuple[bool, str]:
    """
    Evaluates an issue title and body to determine if code changes are required.

    Args:
        title (str): Issue title.
        body (str): Issue description/body text.

    Returns:
        Tuple[bool, str]: A tuple where the first element indicates whether the issue
                          is actionable (True) or not (False), and the second element
                          provides the reasoning.
    """
    text_lower = f"{title}\n{body}".lower()

    # Identifiers for non-actionable policy/honeypot issues
    honeypot_patterns = [
        r"\bexperiment\b",
        r"\bno money will be paid\b",
        r"\bnot real bounties\b",
        r"\bdo not open pull requests\b",
        r"\bguidelines?\b",
        r"\brules?\b",
        r"\bpolicy\b",
        r"\bslop\b",
    ]

    for pattern in honeypot_patterns:
        if re.search(pattern, text_lower):
            return (
                False,
                f"Non-actionable issue detected (matched pattern '{pattern}'). No pull request should be created.",
            )

    # Minimum threshold check for task details
    if len(body.strip()) < 50:
        return False, "Issue description is insufficient or lacks actionable technical detail."

    return True, "Issue appears to be an actionable task."


if __name__ == "__main__":
    # Example validation against the prompt input
    issue_title = "[BOUNTY] Bounties and Issues Guidelines [READ AND OBEY OR BE DISQUALIFIED]"
    issue_body = """
    # About the Bounty
    These guidelines are meant to regulate the process of creating, claiming bounties and payment for this repository.
    This is an experiment being conducted to determine the impact of AI "slop" pull request spam...
    """

    actionable, reason = is_actionable_bounty(issue_title, issue_body)
    print(f"Actionable: {actionable}")
    print(f"Reason: {reason}")
```