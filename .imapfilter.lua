function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

options.timeout = 120
options.subscribe = true
options.charset = "UTF-8"


pass = io.popen('security find-generic-password -s vk-email-password -w')

res = pass:read("*a")
res = string.gsub(res, "\n", "")

vk = IMAP {
  server = 'es.vkcorporate.com',
  username = 'denis.golovachev',
  password = res
}

mailboxes, folders = vk:list_all()
-- print(dump(folders))
-- print(dump(mailboxes))

-- print(dump(vk:list_all('monitoring')))


huntflow = vk.huntflow:is_unseen() *
   vk.huntflow:is_older(7)
huntflow:mark_seen()

vk.INBOX:contain_subject("odkl-datalab-monitoring"):delete_messages()
vk.INBOX:contain_subject("в домене BI более не действителен!"):delete_messages()

for _, monitoring_folder in ipairs(vk:list_all('monitoring')) do
   old_monitoring = vk[monitoring_folder]:is_older(40)
   old_monitoring:delete_messages()
   can_be_skipped = vk[monitoring_folder]:is_older(5)
   can_be_skipped:mark_seen()
end

stash = vk.INBOX:contain_from("git@odnoklassniki.ru") * vk.INBOX:is_older(7)
stash:delete_messages()

results = vk.INBOX:is_unseen() *
          vk.INBOX:contain_subject('DGST')

results:delete_messages()
