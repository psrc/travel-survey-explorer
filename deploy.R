library(rsconnect)

# test version ----

deployApp(account = 'psrcwa',
          appName = 'test-travel-survey-explorer',
          appTitle = 'TEST Travel Survey Explorer')

# official version ----

# deployApp(account = 'psrcwa',
#           appName = 'travel-survey-explorer',
#           appTitle = 'Travel Survey Explorer')
