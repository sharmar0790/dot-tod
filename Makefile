
# BLOG_NAME?=test

# set default shell
SHELL := /bin/zsh -o pipefail -o errexit


.PHONY: list configure-jekyll configure-gem verify
no_targets__:
list:
    # @LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort"

configure-jekyll:
	brew install chruby ruby-install xz openssl@3 
	# brew install openssl@3; \ 
	ruby-install 3.1.4 -- --with-openssl-dir=$$(brew --prefix openssl@3)
	echo "source $$(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc 
	echo "source $$(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc   
	echo "chruby ruby-3.1.4" >> ~/.zshrc \  # run 'chruby' to see actual version
	# @chruby ruby-3.1.4 
	# @source ~/.zshrc || true
	# . ~/.zshrc || true
	cat ~/.zshrc
	source ~/.zshrc; chruby 
	@echo done

verify:
	@echo done
	# Run this after `jekyll` installation
	ruby -v; gem -v; jekyll -v

install-gems:
	bundle add webrick  

configure: configure-jekyll configure-gem verify
	
configure-gem:
	@echo ${HOME} && \
	export GEM_HOME=${HOME}/.gem  && \
	export PATH=${HOME}/.gem/bin:${PATH} && \
	gem install jekyll bundle

clean-jekyll:
	brew uninstall --ignore-dependencies chruby ruby-install xz || true  
	gem cleanup  || true  
	gem uninstall jekyll bundle || true 
	sed -i "" '/chruby/d' ~/.zshrc
	unset GEM_HOME
	unset GEM_PATH
	unset GEM_ROOT
	echo 'done'

create-new-blog:
ifdef BLOG_NAME
	@echo ${BLOG_NAME}
	jekyll new ${BLOG_NAME}
else
	@echo "Please provide the 'BLOG_NAME' to create the blog"
endif		

clean-brew:
	brew autoremove  
	brew cleanup --prune=all

clean-all: clean-jekyll clean-brew	

bc: clean-all configure

# start:
#     bundle exec jekyll serve --open-url --livereload

