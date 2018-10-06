require 'fileutils'
require_relative 'log'
require_relative 'cmn'

class GitRepo

  def self.init_local(project_name, repo_name , repo_type)
    local_repo_path = File.join(Dir.pwd, project_name, repo_name)
    Log.logger.info( "creating #{local_repo_path}")
    FileUtils.mkdir_p local_repo_path
    FileUtils.cp(File.join(Cmn.script_path(1), 'templates', 'buildspec.yml'), local_repo_path)
    setup_code_repo(local_repo_path) if repo_type.eql? RepoType::CODE
    setup_infra_repo(local_repo_path, repo_type) if repo_type.eql?(RepoType::VPC_INFRA) || repo_type.eql?(RepoType::STACK_INFRA)
    Dir.chdir(local_repo_path)
    Cmn.cmd "git init"
  end

  def puslish(repo_name)
    username = Cmn.user_input("Username for \'https://github.com\'")
    Log.logger.info( "Initializing repo #{repo_name}")
    Cmn.cmd "curl -u '#{username}' https://api.github.com/user/repos -d '{\"name\":\"#{repo_name}\"}'"
    Cmn.cmd "git remote add origin git@github.com:#{username}/#{repo_name}.git"
    Cmn.cmd "git remote -v"
    # branch = Cmn.cmd "git branch | grep '*' | cut -d ' ' -f2"
    Cmn.cmd "git push -u origin master"
  end

  def self.setup_infra_repo(local_repo_path, infraType)
    Log.logger.info( "setup_infra_repo")
    cfPathDest = File.join(local_repo_path,'cf')
    FileUtils.mkdir_p cfPathDest
    cfPathSource = File.join(Cmn.script_path(1), 'templates', 'cf')
    FileUtils.cp_r(File.join(cfPathSource, 'vpc'), cfPathDest) if infraType.eql? RepoType::VPC_INFRA
    FileUtils.cp_r(File.join(cfPathSource, 'stack'), cfPathDest) if infraType.eql? RepoType::STACK_INFRA
  end

  def self.setup_code_repo(local_repo_path)
    FileUtils.mkdir_p File.join(local_repo_path,'src')
    FileUtils.cp(File.join(Cmn.script_path(1), 'templates', 'cd', 'appspec.yml'), local_repo_path)
  end

  def self.exists (projectName, repoName)
    value = ""
    if projectName.empty?
      username = Cmn.user_input("Username for \'https://github.com\'")
      value = `git ls-remote https://github.com/#{username}/#{repoName}`
    else
      value = `git ls-remote https://github.com/#{projectName}/#{repoName}`
    end
    return !value.nil? && !value.empty?
  end
end

class RepoType
  STACK_INFRA = "STACK_INRA"
  CODE = "CODE"
  VPC_INFRA = "VPC_INFRA"
end
