# Source this file

REPOS_DIR="$HOME/repos"
OPEN_SOURCE_REPOS_DIR="$REPOS_DIR/opensource"
OPEN_SOURCE_ALGORITHMS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/algorithms"
OPEN_SOURCE_C_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/c"
OPEN_SOURCE_CPP_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/c++"
OPEN_SOURCE_DOCKERFILE_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/dockerfiles"
OPEN_SOURCE_DOCS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/docs"
OPEN_SOURCE_GO_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/go"
OPEN_SOURCE_JAVASCRIPT_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/javascript"
OPEN_SOURCE_LUA_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/lua"
OPEN_SOURCE_PYTHON_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/python"
OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/python_async"
OPEN_SOURCE_SASS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/sass"
OPEN_SOURCE_SHELL_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/shell"
OPEN_SOURCE_TYPESCRIPT_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/typescript"

OPEN_SOURCE_ALGORITHMS_REPOS=(
    https://github.com/TheAlgorithms/Algorithms-Explanation
    https://github.com/TheAlgorithms/C
    https://github.com/TheAlgorithms/C-Plus-Plus
    https://github.com/TheAlgorithms/Go
    https://github.com/TheAlgorithms/Javascript
    https://github.com/TheAlgorithms/Python
)

OPEN_SOURCE_C_REPOS=(
    https://gcc.gnu.org/git/gcc.git
    https://git.savannah.gnu.org/git/bash.git
    https://git.savannah.gnu.org/git/basics.git
    https://git.savannah.gnu.org/git/coreutils.git
    https://git.savannah.gnu.org/git/findutils.git
    https://git.savannah.gnu.org/git/gawk.git
    https://git.savannah.gnu.org/git/make.git
    https://git.savannah.gnu.org/git/sed.git
    https://git.savannah.gnu.org/git/tar.git
    https://git.savannah.gnu.org/git/wget.git
    https://github.com/AndyA/rsync
    https://github.com/Perl/perl5
    https://github.com/antirez/redis
    https://github.com/awesomeWM/awesome
    https://github.com/curl/curl
    https://github.com/git/git
    https://github.com/libuv/libuv
    https://github.com/lua/lua
    https://github.com/nginx/nginx
    https://github.com/openssh/openssh-portable
    https://github.com/postgres/postgres
    https://github.com/python/cpython
    https://github.com/python/devguide
    https://github.com/stedolan/jq
    https://github.com/tmux/tmux
    https://github.com/torvalds/linux
    https://github.com/vim/vim
    https://github.com/zsh-users/zsh
    https://gitlab.gnome.org/GNOME/libxml2.git
    https://gitlab.gnome.org/GNOME/libxslt.git
    https://sourceware.org/git/binutils-gdb.git
    https://sourceware.org/git/dm.git
    https://sourceware.org/git/glibc.git
    https://sourceware.org/git/lvm2.git
)

OPEN_SOURCE_CPP_REPOS=(
    https://github.com/alembic/alembic
    https://github.com/apple/swift
    https://github.com/bitcoin/bitcoin
    https://github.com/fish-shell/fish-shell
    https://github.com/grpc/grpc
    https://github.com/mongodb/mongo
    https://github.com/nodejs/node
    https://github.com/protocolbuffers/protobuf
    https://github.com/tesseract-ocr/tesseract
    https://github.com/v8/v8
)

OPEN_SOURCE_DOCKERFILE_REPOS=(
    https://github.com/jessfraz/dockerfiles
    https://github.com/pyca/infra
)

OPEN_SOURCE_DOCS_REPOS=(
    https://github.com/30-seconds/30-seconds-of-code
    https://github.com/Hack-with-Github/Awesome-Hacking
    https://github.com/airbnb/javascript
    https://github.com/alebcay/awesome-shell
    https://github.com/avelino/awesome-go
    https://github.com/awesomedata/awesome-public-datasets
    https://github.com/braydie/HowToBeAProgrammer
    https://github.com/charlax/professional-programming
    https://github.com/cjbarber/ToolsOfTheTrade
    https://github.com/danistefanovic/build-your-own-x
    https://github.com/donnemartin/system-design-primer
    https://github.com/dylanaraps/pure-bash-bible
    https://github.com/ericdouglas/ES6-Learning
    https://github.com/getify/You-Dont-Know-JS
    https://github.com/git-tips/tips
    https://github.com/jlevy/the-art-of-command-line
    https://github.com/jorgebucaran/awesome-fish
    https://github.com/letsencrypt/website/
    https://github.com/mtdvio/every-programmer-should-know
    https://github.com/nefe/You-Dont-Need-jQuery
    https://github.com/ossu/computer-science
    https://github.com/papers-we-love/papers-we-love
    https://github.com/public-apis/public-apis
    https://github.com/sindresorhus/awesome
    https://github.com/sorrycc/awesome-javascript
    https://github.com/trimstray/the-book-of-secret-knowledge
    https://github.com/tuvtran/project-based-learning
    https://github.com/vinta/awesome-python
    https://github.com/vuejs/awesome-vue
    https://github.com/you-dont-need/You-Dont-Need-JavaScript
    https://github.com/ziishaned/learn-regex
)

OPEN_SOURCE_GO_REPOS=(
    https://github.com/caddyserver/caddy
    https://github.com/docker/docker-ce
    https://github.com/docker/machine
    https://github.com/etcd-io/etcd
    https://github.com/etcd-io/etcd
    https://github.com/flynn/flynn
    https://github.com/gohugoio/hugo
    https://github.com/golang/go
    https://github.com/golang/net
    https://github.com/golang/tools
    https://github.com/gomodule/redigo
    https://github.com/grafana/grafana
    https://github.com/grpc/grpc-go
    https://github.com/hashicorp/consul
    https://github.com/hashicorp/packer
    https://github.com/hashicorp/terraform
    https://github.com/hashicorp/vault
    https://github.com/helm/charts
    https://github.com/helm/helm
    https://github.com/influxdata/telegraf
    https://github.com/istio/istio
    https://github.com/itchyny/gojq
    https://github.com/jwilder/docker-gen
    https://github.com/kubernetes/kubernetes
    https://github.com/kubernetes/minikube
    https://github.com/letsencrypt/boulder
    https://github.com/moby/moby
    https://github.com/mongodb/mongo-go-driver
    https://github.com/rancher/rancher
)

OPEN_SOURCE_JAVASCRIPT_REPOS=(
    https://github.com/LLK/scratch-blocks
    https://github.com/LLK/scratch-gui
    https://github.com/LLK/scratch-render
    https://github.com/LLK/scratch-vm
    https://github.com/LLK/scratch-www
    https://github.com/LLK/scratchjr
    https://github.com/Leaflet/Leaflet
    https://github.com/Unitech/pm2
    https://github.com/babel/babel
    https://github.com/chalk/chalk
    https://github.com/chartjs/Chart.js
    https://github.com/cypress-io/cypress
    https://github.com/d3/d3
    https://github.com/eslint/eslint
    https://github.com/expressjs/express
    https://github.com/facebook/create-react-app
    https://github.com/facebook/react
    https://github.com/freeCodeCamp/freeCodeCamp
    https://github.com/hakimel/reveal.js
    https://github.com/jfo8000/ScratchJr-Desktop
    https://github.com/lodash/lodash
    https://github.com/serverless/serverless
    https://github.com/socketio/socket.io
    https://github.com/statsd/statsd
    https://github.com/tj/commander.js
    https://github.com/typicode/json-server
    https://github.com/vuejs/vue
    https://github.com/winstonjs/winston
    https://github.com/yarnpkg/yarn
)

OPEN_SOURCE_LUA_REPOS=(
    https://github.com/Kong/kong
)

OPEN_SOURCE_PYTHON_REPOS=(
    https://git.savannah.gnu.org/git/ranger.git
    https://github.com/Julian/jsonschema
    https://github.com/Legrandin/pycryptodome
    https://github.com/MagicStack/httptools
    https://github.com/andymccurdy/redis-py
    https://github.com/ansible/ansible
    https://github.com/apache/airflow
    https://github.com/benoitc/gunicorn
    https://github.com/bokeh/bokeh
    https://github.com/boto/boto3
    https://github.com/certbot/certbot
    https://github.com/docker/compose
    https://github.com/geopy/geopy
    https://github.com/ipython/ipython
    https://github.com/jakubroztocil/httpie
    https://github.com/jpadilla/pyjwt
    https://github.com/keon/algorithms
    https://github.com/lxml/lxml
    https://github.com/marshmallow-code/marshmallow
    https://github.com/mongodb/mongo-python-driver
    https://github.com/mvantellingen/python-zeep
    https://github.com/numpy/numpy
    https://github.com/odoo/odoo
    https://github.com/pallets/flask
    https://github.com/pallets/jinja
    https://github.com/pandas-dev/pandas
    https://github.com/powerline/powerline
    https://github.com/psf/black
    https://github.com/psf/requests
    https://github.com/psycopg/psycopg2
    https://github.com/pyca/bcrypt
    https://github.com/pyca/cryptography
    https://github.com/pyca/pyopenssl
    https://github.com/pytest-dev/pytest
    https://github.com/python-pillow/Pillow
    https://github.com/sanand0/xmljson
    https://github.com/scikit-learn/scikit-learn
    https://github.com/scrapy/scrapy
    https://github.com/seatgeek/fuzzywuzzy
    https://github.com/sqlalchemy/alembic
    https://github.com/sqlalchemy/sqlalchemy
    https://github.com/stub42/pytz
    https://github.com/ultrajson/ultrajson
)

OPEN_SOURCE_PYTHON_ASYNC_REPOS=(
    https://github.com/MagicStack/asyncpg
    https://github.com/MagicStack/uvloop
    https://github.com/aio-libs/aiobotocore
    https://github.com/aio-libs/aiohttp
    https://github.com/aio-libs/aioredis
    https://github.com/ashleysommer/sanic-cors
    https://github.com/huge-success/sanic
    https://gitlab.com/pgjones/hypercorn
    https://gitlab.com/pgjones/quart
)

OPEN_SOURCE_SASS_REPOS=(
    https://github.com/jgthms/bulma
)

OPEN_SOURCE_SHELL_REPOS=(
    https://github.com/Bash-it/bash-it
    https://github.com/acmesh-official/acme.sh
    https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion
    https://github.com/nginx-proxy/nginx-proxy
    https://github.com/nvm-sh/nvm
    https://github.com/oh-my-fish/oh-my-fish
    https://github.com/ohmyzsh/ohmyzsh
    https://github.com/paoloantinori/hhighlighter
    https://github.com/pyenv/pyenv
    https://github.com/rupa/z
    https://github.com/wmnnd/nginx-certbot
)

OPEN_SOURCE_TYPESCRIPT_REPOS=(
    https://github.com/angular/angular
    https://github.com/graphql/graphql-js
    https://github.com/ionic-team/ionic
    https://github.com/microsoft/TypeScript
    https://github.com/mrdoob/three.js
    https://github.com/typicode/husky
)

clone-opensource() {
    oldpwd=$(pwd)
    mkdir -p "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR"
    cd "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_ALGORITHMS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_C_REPOS_DIR"
    cd "$OPEN_SOURCE_C_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_C_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_CPP_REPOS_DIR"
    cd "$OPEN_SOURCE_CPP_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_CPP_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR"
    cd "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_DOCKERFILE_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_DOCS_REPOS_DIR"
    cd "$OPEN_SOURCE_DOCS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_DOCS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_GO_REPOS_DIR"
    cd "$OPEN_SOURCE_GO_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_GO_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR"
    cd "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_JAVASCRIPT_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_LUA_REPOS_DIR"
    cd "$OPEN_SOURCE_LUA_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_LUA_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_PYTHON_REPOS_DIR"
    cd "$OPEN_SOURCE_PYTHON_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_PYTHON_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR"
    cd "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_PYTHON_ASYNC_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_SASS_REPOS_DIR"
    cd "$OPEN_SOURCE_SASS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_SASS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_SHELL_REPOS_DIR"
    cd "$OPEN_SOURCE_SHELL_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_SHELL_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR"
    cd "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_TYPESCRIPT_REPOS[@]}"; do
        git clone --recursive $repo
    done
    cd "$oldpwd"
}

[[ -d "$REPOS_DIR" ]] && repos() { cd "$REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR" ]] && opensource-algorithms-repos() { cd "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_C_REPOS_DIR" ]] && opensource-c-repos() { cd "$OPEN_SOURCE_C_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_CPP_REPOS_DIR" ]] && opensource-cpp-repos() { cd "$OPEN_SOURCE_CPP_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR" ]] && opensource-dockerfile-repos() { cd "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_DOCS_REPOS_DIR" ]] && opensource-docs-repos() { cd "$OPEN_SOURCE_DOCS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_GO_REPOS_DIR" ]] && opensource-go-repos() { cd "$OPEN_SOURCE_GO_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR" ]] && opensource-javascript-repos() { cd "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_LUA_REPOS_DIR" ]] && opensource-lua-repos() { cd "$OPEN_SOURCE_LUA_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_PYTHON_REPOS_DIR" ]] && opensource-python-repos() { cd "$OPEN_SOURCE_PYTHON_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR" ]] && opensource-python-async-repos() { cd "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_SASS_REPOS_DIR" ]] && opensource-sass-repos() { cd "$OPEN_SOURCE_SASS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_SHELL_REPOS_DIR" ]] && opensource-shell-repos() { cd "$OPEN_SOURCE_SHELL_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR" ]] && opensource-typescript-repos() { cd "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR"; }
