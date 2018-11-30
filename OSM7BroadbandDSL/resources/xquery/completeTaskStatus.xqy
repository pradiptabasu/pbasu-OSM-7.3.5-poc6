declare namespace saxon="http://saxon.sf.net/";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";

declare namespace context = "java:com.mslv.oms.automation.TaskContext";
declare namespace automator = "java:oracle.communications.ordermanagement.automation.plugin.ScriptReceiverContextInvocation";
declare namespace javaSystem = "java:java.lang.System";
declare namespace javaPrintStream = "java:java.io.PrintStream";
declare namespace javaString = "java:java.lang.String";

declare namespace oms="urn:com:metasolv:oms:xmlapi:1";

declare variable $automator external;
declare variable $context external;

declare variable $EXIT_PATH := "success";

let $taskData := fn:root(.)/oms:GetOrder.Response
let $orderId := $taskData/oms:OrderID/text()
let $taskName := $taskData/oms:Task/text()
let $printStream := javaSystem:out()
let $temp :=
    <oms:Temp>
        <oms:Start>
        {
            javaPrintStream:println($printStream)
        }
        </oms:Start>
        <oms:Log>
        {
            let $taskDataStr := saxon:serialize($taskData, <xsl:output method='xml' omit-xml-declaration='yes' indent='yes' saxon:indent-spaces='4'/>)
            for $char in $taskDataStr 
            return
                javaPrintStream:print($printStream, $char)
        }
        </oms:Log>
        <oms:End>
        {
            javaPrintStream:println($printStream)
        }
        </oms:End>
    </oms:Temp>
return
    if (fn:exists($temp))
    then
    (
        context:completeTaskOnExit($context, $EXIT_PATH)
    )
    else ()

