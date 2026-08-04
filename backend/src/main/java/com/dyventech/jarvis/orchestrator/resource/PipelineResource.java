package com.dyventech.jarvis.orchestrator.resource;

import com.dyventech.jarvis.orchestrator.dto.FeedbackRequest;
import com.dyventech.jarvis.orchestrator.dto.PipelineRequest;
import com.dyventech.jarvis.orchestrator.dto.PipelineResponse;
import com.dyventech.jarvis.orchestrator.service.OrchestratorService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

@Path("/pipeline")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PipelineResource {

    @Inject
    OrchestratorService orchestratorService;

    @POST
    @Path("/start")
    public PipelineResponse start(PipelineRequest request) {
        return orchestratorService.startPipeline(request.getAppName(), request.getUserPrompt());
    }

    @POST
    @Path("/{sessionId}/idea-selection")
    public PipelineResponse ideaSelection(@PathParam("sessionId") String sessionId,
            com.dyventech.jarvis.orchestrator.dto.IdeaSelectionRequest request) {
        return orchestratorService.handleIdeaSelection(sessionId, request.getSelectedId(), request.getFeedback());
    }

    @POST
    @Path("/{sessionId}/script-feedback")
    public PipelineResponse scriptFeedback(@PathParam("sessionId") String sessionId, FeedbackRequest request) {
        return orchestratorService.handleScriptFeedback(sessionId, request.isApproved(), request.getFeedback());
    }
}
