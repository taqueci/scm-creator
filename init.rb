require 'redmine'

begin
    require 'octokit'
rescue LoadError
end

require File.expand_path('lib/scm_creator', __dir__)
require File.expand_path('lib/subversion_creator', __dir__)
require File.expand_path('lib/mercurial_creator', __dir__)
require File.expand_path('lib/git_creator', __dir__)
require File.expand_path('lib/bazaar_creator', __dir__)
require File.expand_path('lib/github_creator', __dir__)

require File.expand_path('lib/scm_config', __dir__)
require File.expand_path('lib/scm_hook', __dir__)

Rails.logger.info 'Starting SCM Creator Plugin for Redmine'

Redmine::Scm::Base.add('Github')

def init()
    unless Project.included_modules.include?(ScmProjectPatch)
        Project.send(:include, ScmProjectPatch)
    end
    unless RepositoriesHelper.included_modules.include?(ScmRepositoriesHelperPatch)
        RepositoriesHelper.send(:prepend, ScmRepositoriesHelperPatch)
    end
    unless RepositoriesController.included_modules.include?(ScmRepositoriesControllerPatch)
        RepositoriesController.send(:prepend, ScmRepositoriesControllerPatch)
    end
    unless Repository.included_modules.include?(ScmRepositoryPatch)
        Repository.send(:include, ScmRepositoryPatch)
    end
end

if Rails.version > '6.0'
    init()
else
    Rails.configuration.to_prepare do
        init()
    end
end

Redmine::Plugin.register :redmine_scm do
    requires_redmine version_or_higher: '4.0'
    name        'SCM Creator'
    author      'Andriy Lesyuk'
    author_url  'http://www.andriylesyuk.com/'
    description 'Allows creating Subversion, Git, Mercurial, Bazaar and Github repositories within Redmine.'
    url         'http://projects.andriylesyuk.com/projects/scm-creator'
    version     '0.5.1.3.0'
end
