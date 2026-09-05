# Code Review

Requesting review, reading and answering threads, and leaving a verdict on
someone else's pull request.

## Requesting

```bash
gh pr edit 42 --add-reviewer octocat,my-org/platform
```

## Reading

```bash
gh pr view 42 --comments
gh pr diff 42 --name-only
gh pr diff 42
```

Line comments are review threads, and `gh` has no subcommand for their
resolution state. Read them through GraphQL:

```bash
gh api graphql -F owner=user -F repo=proj -F pr=42 -f query='
  query($owner:String!,$repo:String!,$pr:Int!){
    repository(owner:$owner,name:$repo){
      pullRequest(number:$pr){
        reviewThreads(first:50){nodes{
          id isResolved path line
          comments(first:5){nodes{author{login} body}}
        }}
      }
    }
  }' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved|not)'
```

## Answering feedback on your own PR

**Answer every open thread.** Reply with what changed and where, or say why the
suggestion was not taken. Silence reads as an oversight.

**Name the commit that fixed it.** GitHub turns a bare short SHA into a link to
that commit, so `Fixed in a1b2c3d` is enough. Read the SHA after the fix lands:

```bash
git log -1 --format=%h
```

Reply with the thread `id` the query above returned:

```bash
gh api graphql -f threadId=<id> -f body='Fixed in a1b2c3d' -f query='
  mutation($threadId:ID!,$body:String!){
    addPullRequestReviewThreadReply(input:{
      pullRequestReviewThreadId:$threadId, body:$body
    }){comment{url}}
  }'
```

Then resolve the thread:

```bash
gh api graphql -f threadId=<id> -f query='
  mutation($threadId:ID!){
    resolveReviewThread(input:{threadId:$threadId}){thread{isResolved}}
  }'
```

**Push follow-up commits while a PR is under review.** A force-push rewrites
what reviewers already read and destroys the "changes since your last review"
diff. Clean the history after approval, or let the squash merge do it.

## Reviewing someone else's PR

Leave a verdict rather than a bare comment:

```bash
gh pr review 42 --approve --body 'Checked the migration path.'
gh pr review 42 --request-changes --body-file /tmp/review.md
gh pr review 42 --comment --body 'One question about the retry budget.'
```

Reply to a thread on someone else's PR, but leave the resolving to the author.
Write access lets you resolve their threads. The decision is still theirs.
