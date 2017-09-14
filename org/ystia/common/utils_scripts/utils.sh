
# Print a log message with the timestamp and level
# params:
#   1- Logging level (debug, info, warning, error)
#   2- Logging message
# Note: do not use ctx for now as it wont work: https://fastconnect.org/jira/browse/SUPALIEN-543
log () {
    local level=$1
    shift
    local time=$(date '+%F %R ')
    local file=$(basename $0)
    local message="$*"
    case "${level,,}" in
      begin) echo "$time INFO: $file : >>> Begin <<< $message" ;;
      end) echo "$time INFO: $file : >>> End   <<< $message" ;;
      *) echo "$time ${level^^}: $file : $message" ;;
    esac
}

# Sometimes it may happen that the $HOME variable is not properly set.
# This function retrieves the user home directory from /etc/passwd based on
# the user returned by the id command
#
ensure_home_var_is_set () {
    # First try to load /etc/profile this will also ensure that required env vars are loaded
    if [[ -f /etc/profile ]]; then
        source /etc/profile
    fi
    # If this is still not set then try with /etc/passwd
    if [[ -z "${HOME}" ]]; then
        export HOME=$(cat /etc/passwd | grep ":$(id --user):" | awk -F : '{print $6;}')
    fi
}
