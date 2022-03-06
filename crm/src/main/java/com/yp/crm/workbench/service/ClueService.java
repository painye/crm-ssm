package com.yp.crm.workbench.service;

import com.yp.crm.workbench.domain.Clue;

/**
 * @author pan
 * @date 2022/3/6 11:04
 */
public interface ClueService {

    /**
     * 添加线索
     * @param clue
     * @return
     */
    int addClue(Clue clue);
}
