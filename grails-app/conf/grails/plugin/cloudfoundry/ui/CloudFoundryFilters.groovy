/* Copyright 2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package grails.plugin.cloudfoundry.ui

import com.vmware.appcloud.client.CloudFoundryClient

/**
 * Ensures that a configured API client is accessible.
 *
 * @author Burt Beckwith
 */
class CloudFoundryFilters {

	def grailsApplication

	def filters = {

		client(controller: 'cloudFoundryDashboard', action: '*') {
			before = {

				def cfConfig = grailsApplication.config.grails.plugin.cloudfoundry
				String cfTarget = cfConfig.target ?: 'api.cloudfoundry.com'
				String cloudControllerUrl = cfTarget.startsWith('http') ?
					cfTarget : 'http://' + cfTarget

				def client
				String token = session.cloudFoundryToken
				if (token) {
					client = new CloudFoundryClient(token, cloudControllerUrl)
				}
				else {
					def credentials = fetchCredentials(cfConfig, session)
					if (credentials) {
						client = new CloudFoundryClient(credentials.username, credentials.password, cloudControllerUrl)
						token = client.login()
						session.cloudFoundryToken = token
					}
					else {
						session['__CF_REDIRECT_URI__'] = request.forwardURI
						redirect controller: 'cfLogin'
						return false
					}
				}

				request.cloudFoundryClient = client
				request.applications = client.applications
			}

			after = { Map model -> }

			afterView = { e -> }
		}
	}

	private fetchCredentials(cfConfig, session) {

		if (session.cfUsername) {
			// logged in interactively
			return [username: session.cfUsername,
			        password: session.cfPassword]
		}

		if (cfConfig.requireLogin) {
			// trigger a redirect to 'login'
			return null
		}

		if (cfConfig.username) {
			return cfConfig
		}

		def stream = getClass().classLoader.getResourceAsStream('cloudfoundry-ui.properties')
		if (stream) {
			stream.withStream { input ->
				def props = new Properties()
				props.load input
				return [username: props.getProperty('grails.plugin.cloudfoundry.username'),
				        password: props.getProperty('grails.plugin.cloudfoundry.password')]
			}
		}

		// trigger a redirect to 'login'
		null
	}
}
