package com.yp.crm.workbench.service;

import com.yp.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * @author pan
 * @date 2022/3/7 8:54
 */
public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkListByClueId(String clueId);

    int addClueRemark(ClueRemark clueRemark);
}
