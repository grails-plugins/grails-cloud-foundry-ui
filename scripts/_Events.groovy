eventCreateWarStart = { warPath, stagingDir ->

	def cfConfig = grailsSettings.config.grails.plugin.cloudfoundry
	if (cfConfig.requireLogin || !cfConfig.username || !cfConfig.password) {
		return
	}

	// Write the username and password into a properties file.
	def propsFile = new File(stagingDir, 'WEB-INF/classes/cloudfoundry-ui.properties')
	Properties props = ['grails.plugin.cloudfoundry.username': cfConfig.username,
	                    'grails.plugin.cloudfoundry.password': cfConfig.password]
	props.store propsFile.newOutputStream(), null
}
