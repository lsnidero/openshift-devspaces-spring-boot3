#!/bin/bash

# @author paragona@sogei.it
# @date 2023-05-02
# @version v1
# available on https://alm-repos.sogei.it/repository/codeready-plugins/assets/scripts/sdi/setup-sdi-v3.sh
set -e


# v1
# 

ALM_BASE_URL=https://SIFEntrate2Collection@dev.azure.com
DPF_SA_0107_BASE_GIT_URL=$ALM_BASE_URL/SIFEntrate2Collection/TP_ENT_SA_0454/_git

REPOS=($DPF_SA_0107_BASE_GIT_URL/sdi-monorepo $DPF_SA_0107_BASE_GIT_URL/sdi-gitops)



clone_repos(){
	cd ${PROJECTS_ROOT}

    for repo in "${REPOS[@]}"
    do
        SHORT_NAME=$(basename $repo)
        echo "----"
        echo "REPO: $repo"
        echo "SHORT_NAME: $SHORT_NAME"
        

        if [ ! -d $SHORT_NAME ]; then
            echo "clono in $PWD"
            git clone $repo
        else
            echo "repo $SHORT_NAME già presente"
        fi
    done
}


create_workspace_file(){
	cd ${PROJECT_SOURCE}

    CODE_WORKSPACE_FILE="sdi.code-workspace"
    TMP_CODE_WORKSPACE_FILE=.${CODE_WORKSPACE_FILE}

    # initialize file
    echo '{"folders": [] }' | jq '.' > $CODE_WORKSPACE_FILE    

    for repo in "${REPOS[@]}"
    do
        SHORT_NAME=$(basename $repo)
        echo "----"
        echo "REPO: $repo"
        echo "SHORT_NAME: $SHORT_NAME"
        
        REPO_FULL_PATH=${PROJECTS_ROOT}/$SHORT_NAME
        echo REPO_FULL_PATH=$REPO_FULL_PATH

        if [ -d ${REPO_FULL_PATH} ]; then
            echo "Aggiungo path al file workspace"
            mv $CODE_WORKSPACE_FILE $TMP_CODE_WORKSPACE_FILE
            REPO_FULL_PATH=$REPO_FULL_PATH jq  '.folders += [{ path: env.REPO_FULL_PATH}]' $TMP_CODE_WORKSPACE_FILE > $CODE_WORKSPACE_FILE
        else
            echo "directory ${REPO_FULL_PATH} non presente"
        fi
    done
	
	mv $CODE_WORKSPACE_FILE $TMP_CODE_WORKSPACE_FILE

	jq  '.extensions.recommendations = ["vscjava.vscode-java-pack", "redhat.vscode-quarkus","sonarsource.sonarlint-vscode", "redhat.fabric8-analytics", "oderwat.indent-rainbow", "mongodb.mongodb-vscode", "redhat.vscode-xml", "redhat.vscode-yaml" ]' $TMP_CODE_WORKSPACE_FILE > $CODE_WORKSPACE_FILE

	mv $CODE_WORKSPACE_FILE $TMP_CODE_WORKSPACE_FILE
    jq  '.settings = {"java.jdt.ls.java.home": "~/.sdkman/candidates/java/current", "maven.executable.preferMavenWrapper": false }' $TMP_CODE_WORKSPACE_FILE > $CODE_WORKSPACE_FILE

    rm $TMP_CODE_WORKSPACE_FILE
}


clone_repos
create_workspace_file
echo "Configuration successful!"


