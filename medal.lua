--https://github.com/shrimp-nz/medal, changed a bit for executors
function decompile(Script)
    local ScriptBytecode = getscriptbytecode(Script)
    if ScriptBytecode then
        local Output = request({
            Url = 'https://decompiler.ashore.rip/decompile',
            Method = "POST",
            Body = ScriptBytecode
        })
        if Output.StatusCode == 200 then
            return Output.Body
        end
        return 'Failed to decompile bytecode\n' .. ScriptBytecode
    end
end
