local discordia = require("discordia")
local client = discordia.Client()

function split(str, ts)
    if ts == nil then return {} end
  
    local t = {} ; 
    i=1
    for s in string.gmatch(str, "([^"..ts.."]+)") do
      t[i] = s
      i = i + 1
    end
  
    return t
end  

client:on("ready", function()
    local guilds = client.guilds:toArray()
    local guild_count = 0
    for _ in pairs(guilds) do
        guild_count = guild_count + 1
    end
    client:setGame("起動してるよ! | " .. tostring(guild_count) .. "Servers")
    print("Logged In | " .. client.user.username)
end)

client:on("messageCreate", function(message)
    if message.content:sub(1, 3) ~= "mo." then
        return
    end
    local args = split(message.content, " ")
    local command = string.gsub(args[1], "mo.", "")
    if command == "help" then
        message.channel:send {
            embed = {
                title = "コマンドリスト(Help)",
                description = "mo.help: このメッセージ\nmo.mute <メンション>: メンション先のユーザーをミュート\nmo.unmute <メンション>: メンション先のユーザーをUnmute\nmo.ban <IDまたはメンション> <理由(任意)>: 指定のユーザーをBan\nmo.unban <ID>: 指定のユーザーをUnban\nmo.kick <メンション>: 指定のユーザーをKick\nmo.purge <メッセージ数>: 指定の個数のメッセージを消すよ!最大は100！メッセージ数を指定してないと50メッセージ消すよ!　　注意点としては消す数より+1多めにしよう！"
            }
        }
    elseif command == "mute" then
        if args[2] == nil then
            message.channel:send("メンションを行うかIDを指定してください。")
            return
        end
        local user_id = string.gsub(args[2], "<", "")
        local user_id = string.gsub(user_id, ">", "")
        local user_id = string.gsub(user_id, "!", "")
        local user_id = string.gsub(user_id, "&", "")
        local user_id = string.gsub(user_id, "@", "")
        local target = message.guild:getMember(user_id)
        if target == nil then
            message.channel:send("メンバーが見つかりませんでした。")
            return
        end
        target:addRole("ミュート用ロールID")
        message.channel:send("ユーザーをミュートにしました。")
    elseif command == "unmute" then
        if args[2] == nil then
            message.channel:send("メンションを行うかIDを指定してください。")
            return
        end
        local user_id = string.gsub(args[2], "<", "")
        local user_id = string.gsub(user_id, ">", "")
        local user_id = string.gsub(user_id, "!", "")
        local user_id = string.gsub(user_id, "&", "")
        local user_id = string.gsub(user_id, "@", "")
        local target = message.guild:getMember(user_id)
        if target == nil then
            message.channel:send("メンバーが見つかりませんでした。")
            return
        end
        target:removeRole("ミュート用ロールID")
        message.channel:send("ユーザーのミュートを解除しました。")
    elseif command == "ban" then
        if args[2] == nil then
            message.channel:send("メンションを行うかIDを指定してください。")
            return
        end
        local user_id = string.gsub(args[2], "<", "")
        local user_id = string.gsub(user_id, ">", "")
        local user_id = string.gsub(user_id, "!", "")
        local user_id = string.gsub(user_id, "&", "")
        local user_id = string.gsub(user_id, "@", "")
        local target = client:getUser(user_id)
        if target == nil then
            message.channel:send("ユーザーが見つかりませんでした。")
            return
        end
        message.guild:banUser(target, args[3])
        message.channel:send("ユーザーをBanしました。")
    elseif command == "unban" then
        if args[2] == nil then
            message.channel:send("IDを指定してください。")
            return
        end
        message.guild:unbanUser(args[2])
        message.channel:send("ユーザーをUnbanしました。")
    elseif command == "kick" then
        if args[2] == nil then
            message.channel:send("メンションを行うかIDを指定してください。")
            return
        end
        local user_id = string.gsub(args[2], "<", "")
        local user_id = string.gsub(user_id, ">", "")
        local user_id = string.gsub(user_id, "!", "")
        local user_id = string.gsub(user_id, "&", "")
        local user_id = string.gsub(user_id, "@", "")
        local target = message.guild:getMember(user_id)
        if target == nil then
            message.channel:send("メンバーが見つかりませんでした。")
            return
        end
        target.kick(args[3])
        message.channel:send("ユーザーをKickしました。")
    elseif command == "purge" then
        local message_count = tonumber(args[2])
        if message_count > 100 then
            message.channel:send("100を超えるメッセージを一斉に消すことは出来ません。")
            return
        end
        local target_channel = message.guild.textChannels:get(tostring(message.channel.id))
        local messages = target_channel:getMessages(message_count):toArray()
        target_channel:bulkDelete(messages)
        message.channel:send("メッセージを削除しました。")
    else
        message.channel:send("コマンドが存在しません。")
    end
end)

client:run("Bot [[BotのToken]]")
