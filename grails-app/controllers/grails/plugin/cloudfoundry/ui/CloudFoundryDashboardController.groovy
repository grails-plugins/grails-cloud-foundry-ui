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

import grails.converters.JSON

import org.springframework.http.client.ClientHttpRequest
import org.springframework.http.client.ClientHttpResponse
import org.springframework.util.FileCopyUtils
import org.springframework.web.client.RequestCallback
import org.springframework.web.client.ResponseExtractor

import com.vmware.appcloud.client.ApplicationStats
import com.vmware.appcloud.client.CloudApplication
import com.vmware.appcloud.client.CloudFoundryException
import com.vmware.appcloud.client.InstanceStats

/**
 * Monitoring UI controller.
 *
 * @author Burt Beckwith
 */
class CloudFoundryDashboardController {

	def index = {}

	def files = {
		[appName: params.appName,
		 instanceIndex: (params.instanceIndex ?: 0).toInteger()]
	}

	def getFiles = {

		def files = []
		String path = params.path ?: '__ROOT__'
		boolean root = false
		if (path == '__ROOT__') {
			root = true
			path = ''
		}

		String contents = request.cloudFoundryClient.getFile(params.appName,
			params.instanceIndex.toInteger(), path)

		for (String line in contents.trim().readLines()) {
			String caption
			String state
			String rel
			String name
			if (line.endsWith('-')) {
				name = line[0..-2].trim()[0..-2]
				caption = name
				state = 'closed'
				rel = 'folder'
			}
			else {
				int index = line.lastIndexOf(' ')
				name = line[0..index].trim()
				String size = line[index..-1].trim()
				caption = name + ' (' + size + ')'
				rel = 'default'
			}
			String filepath = path ? path + '/' + name : name
			def fileData = [data: caption, attr: [path: filepath, rel: rel]]
			if (state) fileData.state = state
			files << fileData
		}

		if (root) {
			files = [attr: [id: 'ROOT', rel: 'drive'],
			         data: params.appName + ' (' + params.instanceIndex + ')',
			         children: files,
			         state: 'open']
		}

		render files as JSON
	}

	def getFile = {
		String contents = request.cloudFoundryClient.getFile(params.appName,
			(params.instanceIndex ?: 0).toInteger(), params.path)
		render text: contents.encodeAsHTML(), contentType: 'text/plain'
	}

	def downloadFile = {

		String path = params.path
		String lowerPath = params.path.toLowerCase()
		boolean binary = lowerPath.endsWith('.jar') ||
			lowerPath.endsWith('.class') ||
			lowerPath.endsWith('.zip') ||
			lowerPath.endsWith('.png') ||
			lowerPath.endsWith('.jpg') ||
			lowerPath.endsWith('.gif') ||
			lowerPath.endsWith('.tar') ||
			lowerPath.endsWith('.gz') ||
			lowerPath.endsWith('.pdf') ||
			lowerPath.endsWith('.ico')

		int index = path.lastIndexOf('/')
		String filename = index > -1 ? path[(index+1)..-1] : path

		response.setContentType 'application/octet-stream'
		response.setHeader 'Content-disposition', 'attachment;filename=' + filename

		if (binary) {
			byte[] bytes = request.cloudFoundryClient.getFile(params.appName,
				(params.instanceIndex ?: 0).toInteger(), path,
				[doWithRequest: { ClientHttpRequest request -> }] as RequestCallback,
				[extractData: { ClientHttpResponse response -> FileCopyUtils.copyToByteArray response.body }] as ResponseExtractor)

			response.outputStream << new ByteArrayInputStream(bytes)
		}
		else {
			String contents = request.cloudFoundryClient.getFile(params.appName,
				(params.instanceIndex ?: 0).toInteger(), params.path)

			response.outputStream << contents.bytes
		}
	}

	def application = {
		for (CloudApplication application in request.applications) {
			if (application.name == params.appName) {
				return [app: application,
				        stats: request.cloudFoundryClient.getApplicationStats(application.name)]
			}
		}
	}

	def services = {
		[services: request.cloudFoundryClient.services]
	}

	def service = {
		[service: request.cloudFoundryClient.getService(params.serviceName)]
	}

	def usageData = {

		def data = [:]

		try {
			ApplicationStats stats = request.cloudFoundryClient.getApplicationStats(params.appName)
			for (InstanceStats instanceStats : stats.records) {
				if (instanceStats.id.equals(params.instanceId)) {
					data.id = instanceStats.id
					if (instanceStats.usage) {
						data.diskUsage = instanceStats.usage.disk
						data.memUsage = instanceStats.usage.mem.toLong()
						data.cpuUsage = instanceStats.usage.cpu
						data.since = instanceStats.usage.time.time
					}
					else {
						data.error = true
					}
				}
			}
		}
		catch (CloudFoundryException ignored) {}

		render data as JSON
	}
}
