# This class holds the webapp parameters
class webapp::params
  (
    Optional[
      Hash[
        String,
	Struct[{
          language => Enum['html', 'php', 'python'],
	  vcs      => Enum['git'],
	  ws       => Struct[{
	    engine        => Enum['apache', 'nginx'],
	    template      => Enum['php-fpm'],
	    template_args => Struct[{
	      listen_port => String[1, default],
	      root_dir    => String[1, default],
	      server_name => String[1, default]
	      }] 
	    }]
	}]
      ]
    ] $webapps,
){}
