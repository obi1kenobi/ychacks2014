child_process = require('child_process')

logDebug      = require('debug')('client:debug')
logError      = require('debug')('client:error')

Client =
  runScript: ({type, name}, cb) ->

    handleProcessEnd = (err, stdout, stderr) ->
      if err?
        if stderr?.length > 0
          logError "Script #{type}-#{name} stderr: #{stderr}"
        else
          logError "Running script #{type}-#{name}, got an error #{err.toString()}"
        return cb?(err)
      logDebug "Script #{type}-#{name} finished."
      return cb?(null)

    path = __dirname + "/#{type}/#{name}.sh"

    logDebug "About to run script at path #{path}"

    process = child_process.execFile path, handleProcessEnd

module.exports = Client