package com.iolive.demo.servlet;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Olive使用HttpService连接java服务端程序的例子
 * 此处使用JavaEE Servlet作为服务端响应程序，strtus、springMVC等同理;
 * 在此示例中使用了Json数据格式和XML数据格式两种，可根据实际情况选择其中一种即可。
 * web.xml配置如下：
 *  <servlet>
 *  	<servlet-class>com.iolive.demo.servlet.OliveHttpService</servlet-class>
 * 	<servlet-name>OliveHttpService</servlet-name>
 * </servlet>
 * <servlet-mapping>
 * 	<servlet-name>OliveHttpService</servlet-name>
 * 	<url-pattern>/OliveHttpService</url-pattern>
 *  </servlet-mapping>
 *  
 *
 */
public class OliveHttpService extends HttpServlet{
	private static final long serialVersionUID = -7059306149367914867L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		String dataType = req.getParameter("dataType");
		Map<String,Object> result = new HashMap<String, Object>();
		if("json".equals(dataType)){
			resp.setContentType("text/plain");
			List<Map<String,Object>> nodes = createNodes();
			result.put("dataType", "json");
			result.put("nodes", listToJson(nodes));
			result.put("arcs", listToJson(createArcs(nodes)));
			JSONObject json = new JSONObject(result);
			resp.getWriter().write(json.toString());
		}else{
			resp.setContentType("text/xml");
			resp.getWriter().write(createXmls());
		}
	}
	
	/**
	 * 节点
	 * 数据源可使用Json、XML等组装至前台
	 * 模拟创建节点，数据源可根据业务需要从业务数据库中读取组装即可
	 * @return
	 */
	private List<Map<String,Object>> createNodes(){
		List<Map<String,Object>> nodes = new ArrayList<Map<String,Object>>(50);
		for(int i = 1; i <= 50; i ++){
			Map<String,Object> node = new HashMap<String, Object>();
			node.put("id", UUID.randomUUID().toString());
			node.put("name", "node"+i);
			node.put("type", "dev");
			node.put("icon", "assets/topo/pstn/terminal.png");
			nodes.add(node);
		}
		return nodes;
	}
	
	
	/**
	 * 线段
	 * 数据源可使用Json、XML等组装至前台
	 * @return
	 */
	private List<Map<String,Object>> createArcs(List<Map<String,Object>> nodes){
		List<Map<String,Object>> arcs = new ArrayList<Map<String,Object>>();
		Map<String,Object> source = null;
		Map<String,Object> destination = null;
		for(int i = 1 ; i < nodes.size(); i ++){
			source = nodes.get(i-1);
			destination = nodes.get(i);
			arcs.add(createArc(source.get("id").toString(),
					destination.get("id").toString()));
		}
		source = nodes.get(nodes.size() -1);
		destination = nodes.get(0);
		arcs.add(createArc(source.get("id").toString(),
				destination.get("id").toString()));
		return arcs;
	}
	
	/**
	 * 模拟创建连接关系线段，数据源可根据业务需要从业务数据库中读取组装即可
	 * @param i
	 * @return
	 */
	private Map<String,Object> createArc(String sourceId,String destinationId){
		Map<String,Object> arc = new HashMap<String, Object>();
		arc.put("id", UUID.randomUUID().toString());
		arc.put("name", sourceId+" --- "+destinationId);
		arc.put("source", sourceId);
		arc.put("destination", destinationId);
		arc.put("type", "join");
		return arc;
	}
	
	/**
	 * Json格式转换
	 * @param list
	 * @return
	 */
	private JSONArray listToJson(List<Map<String,Object>> list){
		List<JSONObject> l = new ArrayList<JSONObject>();
		for(Map<String,Object> m : list){
			l.add(new JSONObject(m));
		}
		return new JSONArray(l);
	}
	
	/**
	 * 创建XML数据源
	 * @return
	 */
	private String createXmls(){
		List<Map<String,Object>> nodes = createNodes();
		StringBuffer xmlStr = new StringBuffer("<graph dataType=\"xml\">");
		for(Map<String,Object> node : nodes){
			xmlStr.append(MessageFormat.format("<node id=\"{0}\" name=\"{1}\" type=\"{2}\" icon=\"{3}\"/>",
					node.get("id"),node.get("name"),node.get("type"),node.get("icon")));
		}
		List<Map<String,Object>> arcs = createArcs(nodes);
		for(Map<String,Object> arc : arcs){
			xmlStr.append(MessageFormat.format("<arc id=\"{0}\" name=\"{1}\" source=\"{2}\" destination=\"{3}\" type=\"{4}\"/>",
					arc.get("id"),arc.get("name"),arc.get("source"),arc.get("destination"),arc.get("type")));
		}
		xmlStr.append("</graph>");
		return xmlStr.toString();
	}
}
