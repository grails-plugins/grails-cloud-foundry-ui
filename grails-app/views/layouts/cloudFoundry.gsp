<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><g:layoutTitle default="Grails" /></title>
	<link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico',plugin:'none')}" type="image/x-icon" />

	<link rel="stylesheet" href="${resource(dir:'css',file:'main.css',plugin:'none')}" />
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'tabs.css', plugin: 'cloud-foundry-ui')}"/>
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'cloudfoundry.css', plugin: 'cloud-foundry-ui')}"/>

	<g:javascript library='jquery' plugin='jquery' />
<g:layoutHead />
</head>

<body>
	<div class="nav">
		<span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
		<span class="menuButton"><a class="list" href="${createLink(controller: 'cloudFoundryDashboard', action: 'services')}">Services</a></span>
		<g:each in='${applications}' var='app'>
		<span class="menuButton"><a class="list" href="${createLink(controller: 'cloudFoundryDashboard', action: 'application')}/${app.name}">Application '${app.name}'</a></span>
		</g:each>
	</div>
	<g:javascript src='jquery.tabs.min.js' plugin='cloud-foundry-ui'/>
	<g:layoutBody />
</body>

</html>
