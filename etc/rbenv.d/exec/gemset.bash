unset GEM_HOME GEM_PATH

if [ "$(rbenv-version-name)" = "system" ]; then
  RBENV_GEMSET_ROOT="$RBENV_GEMSET_SYSTEM_ROOT"
else
  RBENV_GEMSET_ROOT="$(rbenv-prefix)/gemsets"
fi

OLDIFS="$IFS"
IFS=$' \t\n'
for gemset in $(rbenv-gemset active 2>/dev/null); do
  if [ $gemset = "__DEFAULT__" ]; then
    # to avoid infinite loop by evaluating recursively
    default_gem_path=`RBENV_GEMSETS=" " gem env gempath`
    GEM_PATH="$GEM_PATH:$default_gem_path"
  else
    path="${RBENV_GEMSET_ROOT}/$gemset"
    if [ -z "$GEM_HOME" ]; then
      GEM_HOME="$path"
    fi
    if [ -z "$GEM_PATH" ]; then
      GEM_PATH=$path
    else
      GEM_PATH="$GEM_PATH:$path"
    fi
  fi
done
IFS="$OLDIFS"

if [ -n "$GEM_HOME" ]; then
  export GEM_HOME GEM_PATH PATH
fi
