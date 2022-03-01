package com.yp.crm.settings.service;

import com.yp.crm.settings.domain.User;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author pan
 * @date 2022/2/28 15:34
 */

public interface UserService {
    public User queryUserByLoginActAndLoginPwd(Map<String, Object> map);

    public List<User> queryAllUser();

}
