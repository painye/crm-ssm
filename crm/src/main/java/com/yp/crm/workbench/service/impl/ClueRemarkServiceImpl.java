package com.yp.crm.workbench.service.impl;
/**
 * @author pan
 * @date 2022/3/7 8:55
 */

import com.yp.crm.workbench.domain.ClueRemark;
import com.yp.crm.workbench.mapper.ClueMapper;
import com.yp.crm.workbench.mapper.ClueRemarkMapper;
import com.yp.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName : com.yp.crm.workbench.service.impl.ClueRemarkServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/3/7 8:55
 */

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkListByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkListByClueId(clueId);
    }

    @Override
    public int addClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }
}
