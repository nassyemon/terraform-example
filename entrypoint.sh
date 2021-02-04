if [ -z ${ENV} ]; then
  echo "ENV must be specified like 'ENV=dev make init'"
  exit 1
fi
BACKEND_ENV_FILE=env/${ENV}/backend.env
BACKEND_ENVS=$(cat ${BACKEND_ENV_FILE} | grep -v '\#' | xargs )
env ${BACKEND_ENVS} TF_VAR_env=${ENV} ${SHELL} "$@"