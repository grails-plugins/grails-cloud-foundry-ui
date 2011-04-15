<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Services</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name='layout' content='cloudFoundry'/>

<g:javascript>
$(document).ready(function() {
	$('ul.tabs').tabs('div.panes > div')
});
</g:javascript>
</head>

<body>

	<div class="body">

	<ul class="tabs">
		<g:each var='service' in='${services}'>
		<li><a href="#">${service.name}</a></li>
		</g:each>
	</ul>

	<div class='panes'>

	<g:each in='${services}' var='service'>
	<div id="${service.name}TableHolder" class="tabPane">
	<table id="${service.name}Table" cellpadding="0" cellspacing="0" border="0" class="display">
		<tr><td>
<g:render template="service" model="[service: service]" />
		</td></tr>
	</table>
	</div>
	</g:each>

	</div>

	</div>

</body>
</html>
