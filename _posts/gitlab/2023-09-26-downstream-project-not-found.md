---
layout: post
title:  "GITLAB: downstream project not found"
author: commando
categories: [ Gitlab, Pipeline, Multi-Branch-Pipeline ]
featured: false
---

Gitlab has a very good feature of configuring a pipeline in parent-child relationship. In this a parent pipeline will take the responsibility and run the child (downstream) pipelines. 
These features are `multi-branch` or `parent-child` pipelines. These both appraoch works in its own sense and has their own use cases, pros and cons.

In this article, I am going to discuss about very common error we faced during setting up the multi-branch pipeline. In Multi-Branch Pipeline we configure the parent pipeline in such a way it can call the downstream child pipeline. 

In multi Branch pipeline the way we call the downstream is by using the keyword `trigger`.  Inside this we configure the project to be called.

In one of my recent project I was configuring the same design and faced the error `failed (downstream project could not be found)`.

I cheecked every thing like whether I do have the access or not to the projects I am referring ( I have the access), changing the project path etc still the pipeline was not working.

After doing multiple trial and errors and found the solution

I was referring the whole downstream project including `https://<domain>/path/project`.

The solution was very pretty simple
Instead of using `https://<domain>/path/project`, I need to use the `path/project`. After making the changes pipeline starts working.

Let's say you main gitlab project url is something like 
`https://gitlab.com/example/multi-branch-0`

so, in `.gilab-ci.yml`, I need to refer like 
`example/multi-branch-0`

Like this
```yaml
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
    project: example/multi-branch-0
    strategy: depend

paas:
  stage: deploy
  variables:
    env: dev
  trigger:
    project: example/multi-branch-2
    strategy: depend
```