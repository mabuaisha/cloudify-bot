# Description:
#   Add support for cloudify cli commands
#
#
# Commands:
#   cfy get blueprints {{id}} - returns blueprint with specified id .
#   cfy list blueprints - returns all blueprints
#   cfy get deployments {{id}} - returns deployment with specified id
#   cfy list deployments - returns all deployments
#   cfy get executions {{id}} - returns execution with specified id .
#   cfy list executions - returns all executions
#   cfy list nodes - returns all nodes
#   cfy list node-instances - returns all nodes instances
#   cfy list snapshots - returns all snapshots
#   cfy list secrets - returns all secrets
#   cfy get secrets {{id}} - returns secret with specified id
#   cfy list tenants - returns all tenants
#   cfy get tenants {{id}} - returns tenant with specified id
#   cfy list plugins - returns all plugins
#   cfy get plugins - returns plugin  with specified id
#   cfy status - returns manager status



module.exports = (robot) ->

  cloudifyAPIUrl = "http://10.239.1.248/api/v3.1"
  cloudifyUserName = "admin"
  cloudifyPassword = "admin"
  cloudifyTenant =  "default_tenant"

  auth = 'Basic ' + new Buffer(cloudifyUserName + ':' + cloudifyPassword).toString('base64');
  robot.respond /cfy get blueprints (.*)$/i, (msg) ->
    blueprint_id = msg.match[1]
    robot.http("#{cloudifyAPIUrl}/blueprints?id=#{blueprint_id}&_include=id,description,created_by")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Blueprint Id: #{item.id} \n Description: #{item.description} \n  Created By: #{item.created_by}\n"
          return


  robot.respond /cfy list blueprints$/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/blueprints?_include=id,description,created_by")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Blueprint Id: #{item.id} \n Description: #{item.description} \n  Created By: #{item.created_by}\n"
          return


  robot.respond /cfy get deployments (.*)$/i, (msg) ->
    deployment_id = msg.match[1]
    robot.http("#{cloudifyAPIUrl}/deployments?id=#{deployment_id}&_include=id,blueprint_id,tenant_name,created_by")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Deployment Id: #{item.id} \n Blueprint Id: #{item.blueprint_id} \n  Tenant Name: #{item.tenant_name}\n Created By: #{item.created_by}\n"
          return


  robot.respond /cfy list deployments/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/deployments?_include=id,blueprint_id,tenant_name,created_by")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Deployment Id: #{item.id} \n Blueprint Id: #{item.blueprint_id} \n  Tenant Name: #{item.tenant_name}\n Created By: #{item.created_by}\n"
          return


  robot.respond /cfy get executions (.*)$/i, (msg) ->
    execution_id = msg.match[1]
    robot.http("#{cloudifyAPIUrl}/executions/#{execution_id}?_include=id,workflow_id,status,deployment_id")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          msg.send "Execution Id: #{result.id} \n Workflow Id: #{result.workflow_id}\n Status: #{result.status}\n Deployment Id: #{result.deployment_id}"
          return

  robot.respond /cfy list executions/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/executions?_include=id,workflow_id,status,deployment_id")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          msg.send "Status Code is #{res.statusCode}"
          result = JSON.parse(body)
          for item in result.items
            msg.send "Execution Id: #{item.id} \n Workflow Id: #{item.workflow_id}\n Status: #{item.status}\n Deployment Id: #{item.deployment_id}"
          return


  robot.respond /cfy list nodes/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/nodes?_include=id,blueprint_id,deployment_id,host_id,number_of_instances,type")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Node Id: #{item.id} \n Blueprint Id: #{item.blueprint_id} \n  Deployment Id: #{item.deployment_id}\n Host Id: #{item.host_id}\n Number Of Instances: #{item.number_of_instances}\n Node Type: #{item.type}"
          return


  robot.respond /cfy list node-instances/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/node-instances?_include=id,deployment_id,host_id,state")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Node Id: #{item.id} \n Deployment Id: #{item.deployment_id}\n Host Id: #{item.host_id}\n State: #{item.state}"
          return




  robot.respond /cfy list snapshots/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/snapshots?_include=id,status,created_at")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Snapshot Id: #{item.id} \n Status: #{item.status}\n Created At: #{item.created_at}\n"
          return


  robot.respond /cfy list secrets/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/secrets?_include=key,created_at")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Key: #{item.key} \n Created At: #{item.created_at}\n"
          return


  robot.respond /cfy get secrets (.*)$/i, (msg) ->
    secret_id = msg.match[1]
    robot.http("#{cloudifyAPIUrl}/secrets/#{secret_id}")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          msg.send "Key: #{result.key}\n Created At: #{result.created_at}"
          return


  robot.respond /cfy list tenants/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/tenants")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Name: #{item.name} \n Groups: #{item.groups}\n Users: #{item.users}"
          return


  robot.respond /cfy get tenants (.*)$/i, (msg) ->
    tenant_id = msg.match[1]
    robot.http("#{cloudifyAPIUrl}/tenants/#{tenant_id}")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          msg.send "Name: #{result.name}\n Groups : #{result.groups}\n Users: #{result.users}"
          return


  robot.respond /cfy list plugins/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/plugins?_include=id,archive_name")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          for item in result.items
            msg.send "Plugin Id: #{item.id} \n Archive Name: #{item.archive_name}\n"
          return


  robot.respond /cfy get plugins (.*)$/i, (msg) ->
    plugin_id = msg.match[1]
    robot.http("#{cloudifyAPIUrl}/plugins/#{plugin_id}?_include=id,archive_name")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          msg.send "Plugin Id: #{result.id} \n Archive Name: #{result.archive_name}\n"
          return


  robot.respond /cfy status/i, (msg) ->
    robot.http("#{cloudifyAPIUrl}/status")
      .headers(Authorization: auth, Accept: "application/json", Tenant:cloudifyTenant)
        .get()  (err, res, body) ->
          if err
            msg.send "Error From Cloudify: #{err}"

          result = JSON.parse(body)
          msg.send "Status is: #{result.status}\n"
          return
