<#assign isContainFile = 'false'>
<#list fieldList as obj>
    <#if obj.field_operat == 'Y'>
        <#if obj.show_type == '8'>
            <#assign isContainFile = 'true'>
        </#if>
    </#if>
</#list>
package ${tablePd.pack_path}.${tablePd.mod_name}.controller;

import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.qingfeng.base.controller.BaseController;
import com.qingfeng.base.entity.QueryRequest;
import ${tablePd.pack_path}.framework.exception.BizException;
import ${tablePd.pack_path}.${tablePd.mod_name}.entity.${tablePd.bus_name?cap_first};
import com.qingfeng.system.entity.UserOrganize;
import ${tablePd.pack_path}.${tablePd.mod_name}.service.I${tablePd.bus_name?cap_first}Service;
import com.qingfeng.system.service.IUserOrganizeService;
import com.qingfeng.system.service.IUserService;
import com.qingfeng.utils.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import javax.validation.constraints.NotBlank;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * @ProjectName ${tablePd.bus_name?cap_first}Controller
 * @author Administrator
 * @version 1.0.0
 * @Description ${tablePd.menu_name}
 * @createTime 2022/1/19 0019 22:52
 */
@Slf4j
@Validated
@RestController
@RequestMapping("/${tablePd.mod_name}/${tablePd.bus_name}")
public class ${tablePd.bus_name?cap_first}Controller extends BaseController {

    @Autowired
    private I${tablePd.bus_name?cap_first}Service ${tablePd.bus_name}Service;
    @Autowired
    private IUserService userService;
    @Autowired
    private IUserOrganizeService userOrganizeService;

    /**
     * @title listPage
     * @description ??????????????????
     * @author Administrator
     * @updateTime 2022/1/19 0019 22:52
     */
    @GetMapping("/listPage")
    @PreAuthorize("hasAnyAuthority('${tablePd.bus_name}:info')")
    public MyResponse listPage(QueryRequest queryRequest, ${tablePd.bus_name?cap_first} ${tablePd.bus_name}) {
        String userParams = SecurityContextHolder.getContext().getAuthentication().getName();
        //??????????????????
        String user_id = userParams.split(":")[1];
        UserOrganize uoParam = new UserOrganize();
        uoParam.setUser_id(user_id);
        UserOrganize userOrganize = userOrganizeService.findUserOrganizeInfo(uoParam);
        List<String> auth_organize_ids = new ArrayList<String>();
        if(Verify.verifyIsNotNull(userOrganize)){
            if(Verify.verifyIsNotNull(userOrganize.getAuthOrgIds())){
                auth_organize_ids = Arrays.asList(userOrganize.getAuthOrgIds().split(","));
            }
        }
        ${tablePd.bus_name}.setAuth_user(user_id);
        ${tablePd.bus_name}.setAuth_organize_ids(auth_organize_ids);
        Map<String, Object> dataTable = MyUtil.getDataTable(${tablePd.bus_name}Service.findListPage(${tablePd.bus_name}, queryRequest));
        return new MyResponse().data(dataTable);
    }

    /**
     * @title save
     * @description ????????????
     * @author Administrator
     * @updateTime 2022/1/19 0019 22:53
     */
    @PostMapping
    @PreAuthorize("hasAnyAuthority('${tablePd.bus_name}:add')")
    public void save(@Valid @RequestBody ${tablePd.bus_name?cap_first} ${tablePd.bus_name},HttpServletResponse response) throws Exception {
        Json json = new Json();
        try {
            // ????????????
            String id = GuidUtil.getUuid();
            ${tablePd.bus_name}.setId(id);
            String time = DateTimeUtil.getDateTimeStr();
            ${tablePd.bus_name}.setCreate_time(time);
            ${tablePd.bus_name}.setStatus("0");
            ${tablePd.bus_name}.setType("1");
            //??????????????????
            String authParams = SecurityContextHolder.getContext().getAuthentication().getName();
            ${tablePd.bus_name}.setCreate_user(authParams.split(":")[1]);
            ${tablePd.bus_name}.setCreate_organize(authParams.split(":")[2]);

            this.${tablePd.bus_name}Service.save(${tablePd.bus_name});
            json.setSuccess(true);
            json.setMsg("??????????????????");
        } catch (Exception e) {
            String message = "??????????????????";
            json.setSuccess(false);
            json.setMsg(message);
            log.error(message, e);
            throw new BizException(message);
        }
        this.writeJson(response,json);
    }

    /**
     * @title update
     * @description ????????????
     * @author Administrator
     * @updateTime 2022/1/19 0019 22:53
     */
    @PutMapping
    @PreAuthorize("hasAnyAuthority('${tablePd.bus_name}:edit')")
    public void update(@Valid @RequestBody ${tablePd.bus_name?cap_first} ${tablePd.bus_name},HttpServletResponse response) throws Exception {
        Json json = new Json();
        try {
            // ??????????????????
            String time = DateTimeUtil.getDateTimeStr();
            ${tablePd.bus_name}.setUpdate_time(time);
            String authParams = SecurityContextHolder.getContext().getAuthentication().getName();
            ${tablePd.bus_name}.setUpdate_user(authParams.split(":")[1]);
            this.${tablePd.bus_name}Service.updateById(${tablePd.bus_name});
            json.setSuccess(true);
            json.setMsg("??????????????????");
        } catch (Exception e) {
            String message = "??????????????????";
            json.setSuccess(false);
            json.setMsg(message);
            log.error(message, e);
            throw new BizException(message);
        }
        this.writeJson(response,json);
    }

    /**
     * @title delete
     * @description ????????????
     * @author Administrator
     * @updateTime 2022/1/19 0019 22:53
     */
    @DeleteMapping("/{ids}")
    @PreAuthorize("hasAnyAuthority('${tablePd.bus_name}:del')")
    public void delete(@NotBlank(message = "{required}") @PathVariable String ids,HttpServletResponse response) throws Exception {
        Json json = new Json();
        try {
            String[] del_ids = ids.split(StringPool.COMMA);
            this.${tablePd.bus_name}Service.removeByIds(Arrays.asList(del_ids));
            json.setSuccess(true);
            json.setMsg("??????????????????");
        } catch (Exception e) {
            String message = "??????????????????";
            json.setSuccess(false);
            json.setMsg(message);
            log.error(message, e);
            throw new BizException(message);
        }
        this.writeJson(response,json);
    }

    /**
     * @title updateStatus
     * @description ????????????
     * @author Administrator
     * @updateTime 2022/1/19 0019 22:53
     */
    @PostMapping("/updateStatus")
    @PreAuthorize("hasAnyAuthority('${tablePd.bus_name}:status')")
    public void updateStatus(@Valid @RequestBody ${tablePd.bus_name?cap_first} ${tablePd.bus_name},HttpServletResponse response) throws Exception {
        Json json = new Json();
        try {
            this.${tablePd.bus_name}Service.updateById(${tablePd.bus_name});
            json.setSuccess(true);
            json.setMsg("??????????????????");
        } catch (Exception e) {
            String message = "??????????????????";
            json.setSuccess(false);
            json.setMsg(message);
            log.error(message, e);
            throw new BizException(message);
        }
        this.writeJson(response,json);
    }

    /**
     * @title list
     * @description ??????????????????
     * @author Administrator
     * @updateTime 2022/1/19 0019 22:53
     */
    @GetMapping("/list")
    public MyResponse list(${tablePd.bus_name?cap_first} ${tablePd.bus_name}) throws IOException  {
        //??????????????????
        String userParams = SecurityContextHolder.getContext().getAuthentication().getName();
        String user_id = userParams.split(":")[1];
        PageData pd = new PageData();
        pd.put("user_id",user_id);
        PageData orgPd = userService.findUserOrganizeInfo(pd);
        List<String> auth_organize_ids = new ArrayList<String>();
        if(Verify.verifyIsNotNull(orgPd)){
            if(Verify.verifyIsNotNull(orgPd.get("authOrgIds"))){
                auth_organize_ids = Arrays.asList(orgPd.get("authOrgIds").toString().split(","));
            }
        }
        ${tablePd.bus_name}.setAuth_user(user_id);
        ${tablePd.bus_name}.setAuth_organize_ids(auth_organize_ids);
        List<${tablePd.bus_name?cap_first}> list = ${tablePd.bus_name}Service.findList(${tablePd.bus_name});
        return new MyResponse().data(list);
    }

}
