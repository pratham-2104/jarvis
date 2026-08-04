package com.dyventech.jarvis.workspace.resource;

import com.dyventech.jarvis.workspace.dto.WorkspaceDTO;
import com.dyventech.jarvis.workspace.service.WorkspaceService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;

@Path("/workspaces")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class WorkspaceResource {

    @Inject
    WorkspaceService workspaceService;

    @GET
    public List<WorkspaceDTO> list() {
        return workspaceService.listWorkspaces();
    }

    @POST
    public WorkspaceDTO create(WorkspaceDTO workspaceDTO) {
        return workspaceService.createWorkspace(workspaceDTO.getName());
    }

    @GET
    @Path("/{name}")
    public WorkspaceDTO get(@PathParam("name") String name) {
        return workspaceService.getWorkspace(name);
    }

    @DELETE
    @Path("/{name}")
    public Response delete(@PathParam("name") String name) {
        workspaceService.deleteWorkspace(name);
        return Response.noContent().build();
    }

    @GET
    @Path("/{name}/files/content")
    @Produces(MediaType.TEXT_PLAIN)
    public String getFileContent(
            @PathParam("name") String name,
            @QueryParam("subdir") String subdir,
            @QueryParam("fileName") String fileName) {
        return workspaceService.getFileContent(name, subdir, fileName);
    }

    @POST
    @Path("/{name}/files")
    public Response addFile(
            @PathParam("name") String name, 
            @QueryParam("subdir") @DefaultValue("knowledge") String subdir,
            @QueryParam("fileName") String fileName, 
            String content) {
        workspaceService.saveKnowledgeFile(name, subdir, fileName, content);
        return Response.accepted().build();
    }
}
