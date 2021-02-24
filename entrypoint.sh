if [ -z ${ENV} ]; then
  echo "ENV must be specified like 'ENV=dev make init'"
  exit 1
fi
BACKEND_ENV_FILE=env/${ENV}/backend.env
BACKEND_ENVS=$(cat ${BACKEND_ENV_FILE} | grep -v '\#' | xargs)
BE_BUCKET=$(env ${BACKEND_ENVS} sh -c 'echo $BE_BUCKET')
BE_KEY=$(env ${BACKEND_ENVS} sh -c 'echo $BE_KEY')
BE_REGION=$(env ${BACKEND_ENVS} sh -c 'echo $BE_REGION')


GLOBAL_BACKEND_ENV_FILE=env/global/backend.env
GLOBAL_ENVS=$(cat ${GLOBAL_BACKEND_ENV_FILE} | grep -v '\#' | xargs)
GLBOAL_BE_BUCKET=$(env ${GLOBAL_ENVS} sh -c 'echo $BE_BUCKET')
GLOBAL_BE_KEY=$(env ${GLOBAL_ENVS} sh -c 'echo $BE_KEY')
GLOBAL_BE_REGION=$(env ${GLOBAL_ENVS} sh -c 'echo $BE_REGION')

env ${BACKEND_ENVS}\
 TF_VAR_be_bucket=${BE_BUCKET}\
 TF_VAR_be_key=${BE_KEY}\
 TF_VAR_be_region=${BE_REGION}\
 TF_VAR_global_be_bucket=${GLBOAL_BE_BUCKET}\
 TF_VAR_global_be_key=${GLOBAL_BE_KEY}\
 TF_VAR_global_be_region=${GLOBAL_BE_REGION}\
 TF_VAR_env=${ENV}\
 ${SHELL} "$@"