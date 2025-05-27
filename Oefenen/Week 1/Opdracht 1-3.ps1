write-host "The list with all scheduled tasks:"

get-help scheduled

write-host "The number off scheduled tasks:"

(get-help scheduled).count