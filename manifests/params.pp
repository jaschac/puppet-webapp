# This class defines the webapps parameters
class webapps::params
(
  Optional[
    Hash[
      String,
      Struct[{
        owner => Struct[{
          group => String[1, default],
          name  => String[1, default]
          }],
        vcs   => Struct[{
          deployment_key_path => String[1, default],
          engine              => Enum['git'],
          path                => Struct[{
            local  => String[1, default],
            remote => String[1, default]
              }]
          }],
        ws   => Struct[{
          template => Struct[{
            args => Hash,
            name => Enum['gunicorn', 'html', 'php-fpm', 'redirect']
            }]
          }]
        }]
      ]
    ] $apps = {},

  # secrets
  Optional[
    Hash[
      String,
      Struct[{
        vcs => Struct[{
          deployment_key => String[1, default]
          }]
        }]
      ]
    ] $secrets = {}
){}
