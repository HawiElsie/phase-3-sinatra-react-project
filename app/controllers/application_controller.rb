require 'sinatra/base'
require 'json'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get "/projects" do
    projects = Project.all
    projects.to_json(include: :tasks)
  end

  get "/projects/:id" do
    project = Project.find(params[:id])
    project.to_json(include: { boards: { include: :tasks } })
  end

  post "/projects" do
    hash = JSON.parse(request.body.read)
    project = Project.create_new_project_with_defaults(hash)

    if project.save
      { message: "Project successfully created", project: project }.to_json(include: :tasks)
    else
      status 422
      { error: "Project not added" }.to_json
    end
  end

  patch "/projects/:id" do
    project = Project.find(params[:id])

    if project
      data = JSON.parse(request.body.read)
      if project.update(data)
        { message: "Project successfully updated", project: project }.to_json
      else
        status 422
        { error: "Project not updated. Invalid data." }.to_json
      end
    else
      status 404
      { error: "Project not found." }.to_json
    end
  end

  delete "/projects/:id" do
    project = Project.find(params[:id])

    if project && project.destroy
      { message: "Project successfully deleted", project: project }.to_json
    else
      status 404
      { error: "Project not found." }.to_json
    end
  end

  get "/boards" do
    boards = Board.render_all_formatted_for_frontend
    { message: "Boards successfully requested", boards: boards }.to_json
  end

  post "/boards" do
    hash = JSON.parse(request.body.read)
    project = Project.find_by_id(hash["project_id"])

    if project
      board = Board.new(name: hash["name"], project_id: hash["project_id"])
      if board.save
        { message: "Board successfully created", board: board }.to_json
      else
        status 422
        { error: "Board not added. Invalid Data" }.to_json
      end
    else
      status 422
      { error: "Board not added. Invalid Project Id." }.to_json
    end
  end

  patch "/boards/:id" do
    board = Board.find_by_id(params[:id])

    if board
      data = JSON.parse(request.body.read)

      if board.update(data)
        { message: "Board successfully updated", board: board }.to_json
      else
        status 422
        { error: "Board not updated. Invalid data." }.to_json
      end
    else
      status 404
      { error: "Board not found." }.to_json
    end
  end

  delete "/boards/:id" do
    board = Board.find_by_id(params[:id])

    if board && board.destroy
      { message: "Board successfully deleted", board: board }.to_json
    else
      status 404
      { error: "Board not found." }.to_json
    end
  end

  get "/tasks" do
    tasks = Task.render_all_formatted_for_frontend
    { message: "Tasks successfully requested", tasks: tasks }.to_json
  end

  post "/tasks" do
    hash = JSON.parse(request.body.read)
    board = Board.find_by_id(hash["board_id"])

    if board
      task = Task.new(name: hash["name"], board_id: hash["board_id"])
      if task.save
        { message: "Task successfully created", task: task }.to_json
      else
        status 422
        { error: "Task not added. Invalid Data" }.to_json
      end
    else
      status 422
      { error: "Task not added. Invalid Board Id." }.to_json
    end
  end

  patch "/tasks/:id" do
    task = Task.find_by_id(params[:id])

    if task
      data = JSON.parse(request.body.read)

      if task.update(data)
        { message: "Task successfully updated", task: task }.to_json
      else
        status 422
        { error: "Task not updated. Invalid data." }.to_json
      end
    else
      status 404
      { error: "Task not found." }.to_json
    end
  end

  delete "/tasks/:id" do
    task = Task.find_by_id(params[:id])

    if task && task.destroy
      { message: "Task successfully deleted", task: task }.to_json
    else
      status 404
      { error: "Task not found." }.to_json
    end
  end
end
