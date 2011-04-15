/**
 * @author Burt Beckwith
 */
class CloudFoundryUrlMappings {

	static mappings = {
		"/cfDashboard/application/${appName}"(controller: 'cloudFoundryDashboard', action: 'application')
		"/cfDashboard/files/${appName}/${instanceIndex}"(controller: 'cloudFoundryDashboard', action: 'files')
		"/cfDashboard/service/${serviceName}"(controller: 'cloudFoundryDashboard', action: 'service')
	}
}
