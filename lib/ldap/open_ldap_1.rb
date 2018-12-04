module NauLdap
  class OpenLdap1 < OpenLdap

    # Путь для подключения к OpenLdap1
    BIND_OL1_DN = 'uid=hradmin,ou=users,dc=naumen,dc=ru'.freeze

    # Путь поиска учетных записей в OpenLdap1
    SEARCH_TREE_BASE_OL1 = "ou=users,dc=naumen,dc=ru".freeze

    # Одинаковые атрибуты для создания всех учетных записей в OpenLdap1
    OL1_STATIC_ATTRIBUTES = {
      objectClass:    %w[inetOrgPerson posixAccount shadowAccount top],
      loginShell:     '/usr/bin/passwd',
      shadowInactive: '0',
      shadowWarning:  '0',
      shadowFlag:     '0',
      shadowMin:      '0',
      shadowMax:      '99999',
      shadowExpire:   '99999',
      gidNumber:      '57925'
    }.freeze

    private

    def login_attribute
      'uid'
    end

    def search_treebase
      SEARCH_TREE_BASE_OL1
    end

    def bind_dn
      BIND_OL1_DN
    end

    def set_dn(attrs)
      "uid=#{attrs[:uid]},ou=users,dc=naumen,dc=ru"
    end

    def static_attributes
      OL1_STATIC_ATTRIBUTES
    end

    def dynamic_attributes(attrs)
      transform_arguments(attrs)
    end

    def hr_id
      'employeeNumber'
    end

    def transform_arguments(attrs)
      {
        uid:                        attrs['uid'],
        displayName:                attrs['uid'],
        givenName:                  attrs['firstName'],
        sn:                         attrs['lastName'],
        l:                          attrs['city'],
        physicalDeliveryOfficeName: attrs['physicalDeliveryOfficeName'],
        title:                      attrs['position'],
        telephoneNumber:            attrs['telephoneNumber'],
        employeeNumber:             attrs['hrID'],
        userPassword:               md5_password(attrs['password']),
        mail:                       "#{attrs['uid']}@naumen.ru",
        homeDirectory:              "/home/users/#{attrs['uid']}",
        uidNumber:                  set_uidNumber.to_s,
        cn:                         "#{attrs['lastName']} #{attrs['firstName']} #{attrs['middleName']}"
      }
    end
  end
end