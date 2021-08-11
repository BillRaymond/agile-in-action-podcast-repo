---
# layout: tech-post
categories: tech-blog
date: 2020-09-02T18:00:00.000-07:00
author: Bill Raymond
title: 'Agile ideas: Create a Kanban Board in Microsoft Project (desktop)'
featuredImage: "/uploads/screen-shot-2020-09-02-at-5-44-30-pm.png"
---
Microsoft Project may not be your typical agile project management tool, but here's an interesting approach.

In my post, [An introduction to agile: The history of agile and project management](he-history-of-agile-and-project-management.html), I share how businesses are shifting from a traditional _waterfall_ approach to an agile-based method for managing projects.

If you aren't one for reading, I created a video lesson you can watch here:

[https://youtu.be/3lG7vpXNyu0](https://youtu.be/3lG7vpXNyu0 "https://youtu.be/3lG7vpXNyu0")

The _waterfall_ method assumes you plan all your work upfront, defining all the tasks, and linking them together into a perfect chain we call the _critical path_. In agile, you build a product backlog.

In most agile organizations, the product backlog is maintained by a role called the Product Owner. The teams doing the work manage a sprint backlog. The sprint backlog is a set of work the team prioritized for a sprint, which is very often a period of time between 1-3 weeks.

## Introducing the Kanban board

A simple and intuitive way to manage work is to use a _Kanban board_, which, as you will see is a table with a set of columns.

The columns go from left-to-right, starting with a backlog of work (product backlog, sprint backlog, to-do list, etc.). When items in the backlog are in progress, you simply move them to different columns that show work progress until they are in the _done_ (finished, completed, etc.) column.

![](/uploads/work-4096927_1920.jpg)

## Microsoft Project and Kanban

You would think that Microsoft Project, being a waterfall-based scheduling tool would not be useful for managing agile projects. To an extent, that is true, although the latest version of the Microsoft Project Online desktop version, does have a built-in _agile board_ capability.

A common misperception in project management is that agile suggests teams _do what they want whenever they want_. That is not true and not a best practice. In fact, work should always have priorities and sometimes, we have to meet critical deadlines. Project Managers and Project Owners often want some semblance of a plan while still allowing teams to select the work they can do based on a set of priorities.

What all that means is that agile teams are free to select what they will do for a given sprint, but not necessarily pick and choose their favorite things from the entire backlog.

## Microsoft Project: The hybrid approach

![](/uploads/charging-station-logo-5261309_1280.png)

If you are in an organization where it is still important to plan a schedule, but also want to use agile techniques, then you are likely using a hybrid approach to managing the work. You are probably not creating a detailed critical path for every single work element in a plan, but you are still at least building timelines and using some form of a Kanban board.

As I mentioned earlier in this article, Microsoft Project Online (desktop) has the ability to create agile boards, but what if you do not have the online version or a previous version?

## Pre-requisites

With the approach I layout in this article, you will learn how to create a Kanban report using:

* Microsoft Project 2013
* Microsoft Project 2016
* Microsoft Project 2019
* Project Online (desktop), but it would be duplicative since the built-in _agile board_  feature provides the same (and more) functionality

Optionally, you can download a copy of my sample project. Donations are accepted, but you can just type $0 for a free version.

<script src="https://gumroad.com/js/gumroad-embed.js"></script>
<div class="gumroad-product-embed" data-gumroad-product-id="FUAno"><a href="https://gumroad.com/l/FUAno">Loading...</a></div>

## Create the project

1. Run Microsoft Project and create a new project or open your favorite project. I provide a sample
2. Click on the report tab.
3. Locate the View Reports section and click the New Report icon. A menu appears as shown in the next image. Select the Blank item. 
4. The Report Name dialog appears. Type Kanban Board.