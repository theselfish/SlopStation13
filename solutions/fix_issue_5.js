// Solution for issue #5
// Generated automatically by Baobot

const axios = require('axios');

const issueNumber = 5;
const bountyAmount = 600;
const issueTitle = "Add Thursday's Boots";
const issueLink = "https://github.com/theselfish/SlopStation13/issues/5";

async function createIssue() {
    const response = await axios.post('https://api.github.com/repos/theselfish/SlopStation13/issues', {
        title: issueTitle,
        body: `Bounty: ${bountyAmount} - ${issueTitle}\n\n${issueLink}`
    }, {
        headers: {
            'Authorization': `token ${process.env.GITHUB_TOKEN}`,
            'Accept': 'application/vnd.github.v3+json'
        }
    });

    if (response.status === 201) {
        console.log(`Issue created successfully with ID: ${response.data.number}`);
    } else {
        console.error('Failed to create issue:', response.data.message);
    }
}

createIssue();


This script uses the `axios` library to create an issue on the GitHub repository `theselfish/SlopStation13` with the specified bounty amount and issue title. Make sure to replace `process.env.GITHUB_TOKEN` with your actual GitHub personal access token that has the necessary permissions to create issues.