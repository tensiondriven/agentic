# Agentic

There are a number of tools for working with AI agents, but few to none written in Elixir. Elixir is well suited for agent swarms thanks to erlang's actor model; Agents and message passing are first-class citizens in Elixir.

Agentic is heavily inspired by crewai and open interpreter as explained below:

- Crewai supports rich primitives for composing ai agent workflows, but requires writing python code to do the composition. Agentic uses yaml for configuration (similar to Home Assistant), so all agent configs can be source controlled, written without any programming experience, and potentially manipulated at runtime.

- Open interpreter provides wonderful tool usage and a very intuitive cli interface, but lacks dynamic agent definition and agent collaboration. Agentic seeks to make each agent capable of performing common operations (tool usage), much like open interperter.

## Motivation

There seems to be a sweet spot that is missing in the local AI space which I feel would be well informed by the values of the Elixir community. Existing tools try to do too much, assume too much, and lack a good developer/user experience.

Also, I'm not a fan of python. I'd love to have the primitives to do AI agent work available in Elixir-land. As such, this repo has a bit of a split brain, with the motivation of serving two different use cases:

- hex dep for working with ai agents via openai-compatible api's (local and remote)
- task runner for executing agent swarms, described in yaml files and executed via mix tasks

## Goals

- Allow users to create AI agents, teams, tasks, etc using yaml
- Provide json schema to validate the yaml
- Allow agents to use basic tools:
  - Search the web
  - Write files
  - Use bash
  - Ask the user a question
- Allow agents to write new agent, team, task specifications, and to validate and instantiate them
- Allow agents to maintain PKM's in markdown
- Plan and track progress towards goals (at agent and team-level)
- BYO LLM, local or remote (via openai compatible rest api)
- Fast, light-weight, simple, useful

## Non-goals

- Integration with [Bumblebee](https://github.com/elixir-nx/bumblebee) or any machine learning framework. Agentic seeks to be "glue code" which will interoperate with LLM's via an openai-compatible REST API.
- Database persistence. Agentic seeks to maintain state via the filesystem, much as a team would collaborate on a shared network drive.
- Python `\*``
- React

`*` it may make sense to leverage open interperter via some kind of python invocation to avoid having to implement much of open interperter in elixir

## Roadmap

- [ ] Support writing agent, team, and task specifications
- [ ] Spin 'em up and watch em go (via CLI)
- [ ] Add tools
- [ ] Agents maintain and update project notes, markdown files published via simple web server
- [ ] Visualization of interactions/progress/results (Web or TUI)

## Usage

If you'd like to play around with this project, i encourage you to clone the project and run the tests to see what it does so far. Forks and stars certainly welcome!

## Contributing

This is starting as a personal passion project and is still very experimental. Given the nature of such projects, it may stagnate or move in fits and starts. The best way for it to become something truly useful is for others to build on it, so your contributions are welcome and celebrated. I would very much not like to be the only author in the git history.

If you have ideas or questions about how this package might grow, or if any of the goals or roadmap inspire you, feel free to [open an issue](https://github.com/tensiondriven/agentic/issues/new) to start a discussion. PR will be celebrated and accepted blindly!
