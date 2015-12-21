# This class holds the webapp parameters
class webapp::params
  (

    # secrets (eYAML)
    Optional[
      Hash[
        String,
        Struct[{
          vcs => Struct[{
            deployment_key => Optional[String[1, default]]
          }]
        }]
      ]
    ] $secrets,

    # webapps (YAML)
    Optional[
      Hash[
        String,
	Struct[{
          extra_dependencies => Optional[
            Hash[
              String[1, default],
              String[1, default]
              ]
            ],
          language           => Struct[{
            engine          => Enum['html', 'php', 'python', 'ruby'],
            limits          => Optional[
              Struct[{
                max_size_post   => Optional[String[1, default]],
                max_size_upload => Optional[String[1, default]]
              }]
            ]
          }],
	  vcs                => Struct[{
            engine         => Enum['git']
          }],
	  ws                 => Struct[{
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
    ] $webapps
){}
