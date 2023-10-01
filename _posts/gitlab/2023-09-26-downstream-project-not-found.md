---
layout: post
title:  "GITLAB: Error - downstream project not found"
author: commando
categories: [ Gitlab, Pipeline, Multi-Branch-Pipeline ]
image: assets/images/gitlab-pipeline.jpeg
featured: false
---

Now a days dynamic pipelines becomes a default process in every organisation. To make the devops flow smooth, less code, more work, so to provide coherent and efficient workflows. Gitlab has a very good feature of configuring a pipeline in parent-child relationship. In this a parent pipeline will take the responsibility and run the child (downstream) pipelines. 
These features are `multi-branch` or `parent-child` pipelines. These both appraoch works in its own sense and has their own use cases, pros and cons.

In this article, I am going to discuss about very common error we faced during setting up the multi-branch pipeline. In Multi-Branch Pipeline, we configure the parent pipeline in such a way it can call the downstream child pipeline. 

The way pipeline call the downstream is by using the keyword `trigger`.  Inside this we configure the project to be called.
Syntax:

```yaml
trigger:
    project: example/multi-branch-2
    strategy: depend
```

In one of my recent project I was configuring the same design and faced the error `failed (downstream project could not be found)`.

I checked every thing like whether I do have the access or not to the projects I am referring ( I have the access), changing the project path etc still the pipeline was not working. I googled the error like hell. After doing multiple trial and errors and found the solution

The solution was quite very simple. I was referring the whole downstream project including the domain like - `https://<domain>/path/project`.

Instead of using `https://<domain>/path/project`, I had to use the `path/project`. So, everything after domain we have to include the rest of the path. 
After making the changes pipeline starts working.

**Example:**
Let's say your main gitlab project url is something like 
`https://gitlab.com/example/project-A`

so, in `.gilab-ci.yml`, I need to refer like 
`example/child-project-A`

Like this
```yaml
# Parent Project ci yml file
variables:
  DEPLOY_ENVIRONMENT:
    value: "dev"
    options:
      - "dev"
      - "sit"
      - "pse"
    description: "The deployment target. Set to 'dev' by default."

stages:
  - deploy

caas:
  stage: deploy
  variables:
    env: ${DEPLOY_ENVIRONMENT}
  trigger:
    project: example/cild-project-A
    strategy: depend

paas:
  stage: deploy
  variables:
    env: dev
  trigger:
    project: example/child-project-B
    strategy: depend
```