<html>
<head>
	<meta name='layout' content='cloudFoundry'/>
	<title>Directory Listing</title>

	<g:javascript src='jquery.cookie.js' />
	<g:javascript src='jquery.hotkeys.js' />
	<g:javascript src='jquery.jstree.js' />

	<link rel="stylesheet" href="${resource(dir:'css', file: 'fileView.css')}" />
</head>
<body>

<div id="container">
	<div id="fileTree" class="fileTree"></div>
	<div id="fileContents" class="fileContents"></div>
	<script type="text/javascript">
	var appName = '${appName}';
	var instanceIndex = '${instanceIndex}'
	var getFilePath = '${createLink(action: 'getFile')}';
	var getFilesPath = '${createLink(action: 'getFiles')}';
	var downloadFilePath = '${createLink(action: 'downloadFile')}';
	var fileImagePath = '${resource(dir: 'images/fileview', file: 'file.png', plugin: 'cloud-foundry-ui')}';
	var folderImagePath = '${resource(dir: 'images/fileview', file: 'folder.png', plugin: 'cloud-foundry-ui')}';
	var rootImagePath = '${resource(dir: 'images/fileview', file: 'root.png', plugin: 'cloud-foundry-ui')}';
	</script>
	<g:javascript src='fileView.js'/>
</div>

</body>
</html>
