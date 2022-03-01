package com.yp.crm.settings.service.impl;
/**
 * @author pan
 * @date 2022/2/28 15:37
 */

import com.yp.crm.settings.domain.User;
import com.yp.crm.settings.mapper.UserMapper;
import com.yp.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @ClassName : com.yp.crm.settings.service.impl.UserServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/2/28 15:37
 */

@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;


    @Override
    public User queryUserByLoginActAndLoginPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndLoginPwd(map);
    }

    @Override
    public List<User> queryAllUser() {
        return userMapper.selectAllUser();
    }
}
